# intrees-stel
Customization of Houtao Deng's inTrees-STEL analysis - repetitions are parallelized, performance of the original Random Forest is saved for comparison, and the code is cleaned up a bit.

Code and data from https://sites.google.com/site/houtaodeng/intrees

Datafile is https://dl.dropboxusercontent.com/u/45301435/inTrees_STEL_Data_For_Paper.zip

# Example output

Results from 10 repetitions. Random Forests contain 100 trees.
```r
> aveMat[order(rownames(aveMat)), ]
                     STEL      rpart         RF
anneal.data   0.070568562 0.10568562 0.05752508
austra.data   0.162608696 0.14608696 0.12956522
auto.data     0.276470588 0.36029412 0.20735294
breast.data   0.049785408 0.05622318 0.03476395
crx.data      0.163043478 0.14826087 0.12652174
german.data   0.278678679 0.27537538 0.23993994
glass.data    0.311267606 0.33521127 0.23802817
heart.data    0.223333333 0.23555556 0.17888889
hepati.data   0.194230769 0.18653846 0.14615385
horse.data    0.191869919 0.16097561 0.14065041
iris.data     0.046000000 0.05400000 0.04200000
labor.data    0.131578947 0.18421053 0.04736842
led7.data     0.278069353 0.32764761 0.27291471
lymph.data    0.181632653 0.27551020 0.18571429
pima.data     0.269140625 0.26835938 0.24570312
tic-tac.data  0.002194357 0.09435737 0.02351097
vehicle.data  0.289361702 0.32659574 0.25212766
waveform.data 0.200119976 0.26328734 0.15044991
wine.data     0.076271186 0.12372881 0.01525424
zoo.data      0.058823529 0.19705882 0.04411765
```

Results from 100 repetitions. Random Forests contain 100 trees.
```r
> aveMat[order(rownames(aveMat)), ]
                     stel      rpart         rf
anneal.data   0.069464883 0.10157191 0.05775920
austra.data   0.158782609 0.14721739 0.13239130
auto.data     0.254264706 0.38926471 0.20661765
breast.data   0.047553648 0.05922747 0.03090129
crx.data      0.162086957 0.14934783 0.12973913
german.data   0.288138138 0.27690691 0.24060060
glass.data    0.308169014 0.34028169 0.23380282
heart.data    0.215333333 0.22855556 0.17900000
hepati.data   0.211346154 0.21403846 0.16038462
horse.data    0.205447154 0.16585366 0.15227642
iris.data     0.049000000 0.05720000 0.04620000
labor.data    0.155263158 0.22421053 0.08263158
led7.data     0.268594189 0.31776007 0.26522024
lymph.data    0.206734694 0.26183673 0.16040816
pima.data     0.274843750 0.25781250 0.23875000
tic-tac.data  0.003416928 0.09291536 0.02614420
vehicle.data  0.279787234 0.32258865 0.25163121
waveform.data 0.199526095 0.26463707 0.15075585
wine.data     0.079322034 0.13288136 0.02491525
zoo.data      0.069117647 0.19441176 0.05941176
```
