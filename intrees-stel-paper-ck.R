# Citation
# Houtao Deng, Interpreting Tree Ensembles with inTrees, Houtao Deng, arXiv:1408.5456, 2014
# The code below produces the results in the paper above (randomness of the tree ensembles can lead to slight differences of the results)
# See https://sites.google.com/site/houtaodeng/intrees

# This version modified by Chris Kennedy to save RF performance, run repetitions in parallel, and clean up code.

# rm(list=ls(all=TRUE))
library(inTrees)
library(randomForest)
library(rpart)
library(pROC)
graphics.off()

# CK: Enable parallel processing.
library(doMC)
registerDoMC(cores=7)
# Confirm the # of cores being used.
getDoParWorkers()

# Set the seed for reproducibility.
set.seed(1408)

# Number of repetitions per dataset. In the paper it is set to be 100.
nRep <- 10 

dataV <- c("iris.data","auto.data","breast.data","pima.data","heart.data","german.data","waveform.data","horse.data","austra.data",
"crx.data","vehicle.data","labor.data","wine.data","zoo.data","tic-tac.data","hepati.data","lymph.data","anneal.data",
"glass.data","led7.data")

eAll <- NULL; fAll <- NULL

# dataV = c("led7.data")

# Loop through each dataset.
time = system.time({
for(dataI in 1:length(dataV)) {
  thisData <- dataV[dataI]
  cat("\nDataset: ", thisData, "\n")
  path <- paste(getwd(), "/data/",thisData,sep="")

  # R 3.1.1 seems to have a bug on parsing '?' as NA when it is in the begining of a row
  # hence use a temporary solution below
  X <- read.table(path,header=TRUE,sep = ",")
  X[X[,] == "?"] <- NA
  write.table(X,"tmp.txt",col.names = TRUE,quote=FALSE,sep = ",")
  X <- read.table("tmp.txt",header=TRUE,sep = ",",na.strings <- c(''))

  Y <- X[,ncol(X)]
  X <- X[,-ncol(X)]
  for (ii in ncol(X):1) { 
    # Remove attributes with 1 or 0 level.
    if (length(unique(X[!is.na(X[,ii]),ii])) <= 1) {
      X <- X[,-ii] 
    }
  }

  # Impute Missing Values by median/mode.
  X <- na.roughfix(X)
  
  # This is 10 repeats of 2/3 training 1/3 test performance evaluation.
#   for(foldI in 1:nRep) {
  results <- foreach(foldI = 1:nRep, .combine = rbind) %dopar% {
    # Put 2/3 into training, 1/3 into test.
    ixTrain <- sample(1:nrow(X),round(2*nrow(X)/3),replace=FALSE)
    ixTest <- setdiff(1:nrow(X),ixTrain)
  
    testX <- X[ixTest,]
    trainX <- X[ixTrain,]
    testY <- as.character(Y[ixTest])
    trainY <- as.character(Y[ixTrain])

    # Orig RF and calculate the importance
    # NOTE: may want to expand to 500+ trees. Ideally would also optimize mtry. 
    rf <- randomForest(trainX, as.factor(trainY), ntree=100)  

    # CK: Predict original RF on test set and save performance.  
    pred = predict(rf, type = "class", newdata = testX)
    errRF = 1 - sum(pred == testY)/length(pred);
    
    # Process the RF.
    treeList <- RF2List(rf)
    ruleExec <- extractRules(treeList,trainX) 
    # Remove same rules. NOTE: for variable interaction analysis, you should NOT perform this step.
    ruleExec <- unique(ruleExec) 
    
    #randomly select 2000 rules
    ix <- sample(1:length(ruleExec), min(2000,length(ruleExec))) 
    ruleExec <- ruleExec[ix,,drop=FALSE]

    ruleMetric <- getRuleMetric(ruleExec,trainX,trainY)
    ruleMetric <- pruneRule(ruleMetric,trainX,trainY,typeDecay = 1)
    ruleMetric <- unique(ruleMetric)

    ruleClassifier <- buildLearner(ruleMetric,trainX,trainY)
    readable <- presentRules(ruleClassifier,colnames(trainX))
    pred <- applyLearner(ruleClassifier,testX)
    errRFInTrees=1-sum(pred==testY)/length(pred);

    # Run rpart on the training set.
    trainX <- data.frame(trainX)
    D <- data.frame(cbind(trainX,trainY))
    D[,"trainY"] <- as.factor(D[,"trainY"])
    rp <- rpart(trainY ~. , D)
    
    # Look at test set performance.
    pred <- as.character(predict(rp, data.frame(testX), type="class"))
    errRPART <- 1 - sum(pred == testY)/length(pred);
  
    # Save our results.
    thisE <- c(stel = errRFInTrees, rpart = errRPART, rf = errRF)
    cat("foldI", foldI, thisE, "-  ")
    
    # Return the result for foreach/dopar to combine.
    thisE
  }
  eAll = rbind(eAll, results)
  # Show average performance across the folds for each algorithm.
  print(apply(results, 2, mean))
}
}) # End system.time()
time

# colnames(eAll) <- c("STEL","rpart", "RF")

# Average error for each data set
aveMat <- NULL
nRep <- nrow(eAll)/length(dataV)
for(I in 1:length(dataV)) {
  thisE <- eAll[((I-1)*nRep+1):(I*nRep),]
  aveMat <- rbind(aveMat, apply(thisE, 2, mean))
}

# Use the data files as rownames.
rownames(aveMat) = dataV

# Compare performance to inTree.
aveMat - aveMat[,1]

# Overall performance, sorted by data file name.
aveMat[order(rownames(aveMat)), ]
