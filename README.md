# intrees-stel
Customization of Houtao Deng's inTrees-STEL analysis - repetitions are parallelized, performance of the original Random Forest is saved for comparison, and the code is cleaned up a bit.

Code and data from https://sites.google.com/site/houtaodeng/intrees

# Example output
Based on 10 repetitions.
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
