# Repeats for 100 times for random forest and svm
# All default set and still need same tuning for parameters.
library(randomForest)
library(e1071)

accuracy_rf_svm <- matrix(0, ncol = 2, nrow = 2)
colnames(accuracy_rf_svm) = c('train','test')
rownames(accuracy_rf_svm) = c('randomforest','svm')
reps = 100
count = 0
for (i in 1:reps) {
  # Split train and test data sets
  data <- split_train_test(df_flat_img, 0.3)
  # Random Forest
  rffit <- randomForest(data$train[,-1], as.factor(data$train[,1]))
  accuracy_rf_svm[1,1] = accuracy_rf_svm[1,1] + mean(svmfit$fitted==data$train[,1])/reps
  accuracy_rf_svm[1,2] = accuracy_rf_svm[1,2] + mean(predict(svmfit, data$test[,-1])==data$test[,1])/reps
  # SVM 
  svmfit <- svm(data$train[,-1], as.factor(data$train[,1]), probablity = T, cross = 3,
                type = "C-classification", method = "SVM")
  accuracy_rf_svm[2,1] = accuracy_rf_svm[2,1] + mean(svmfit$fitted==data$train[,1])/reps
  accuracy_rf_svm[2,2] = accuracy_rf_svm[2,2] + mean(predict(svmfit, data$test[,-1])==data$test[,1])/reps
  
  count = count +1
  print(count)
}

#####################################
##            #  trian  ##   test  ##
#####################################
##randomforest#0.7078095##0.8242222##
#####################################
##    svm     #0.8789524##0.6934444##
#####################################