# Librarys
library(randomForest)
library(e1071)
# New functions
# Functions: 1. split_train_test: split data into train and test by rate in average of 2 groups.
#            2. get_3d_location : get the vector number back into 3D pixel position.
split_train_test <- function(dataframe, rate = .2, split_name = 'malignant') {
  dataframe <- as.data.frame(dataframe)
  n <- nrow(dataframe)
  split_id <- split(1:n, dataframe[,split_name])
  split_n <- sapply(split_id, nrow)
  test_id <- c()
  for (i in 1:length(split_n)) {
    get_test <- sample(split_id[[i]], size = floor(length(split_id[[i]])*rate))
    test_id <- c(test_id, get_test)
  }
  train_data <- dataframe[-test_id,]
  test_data <- dataframe[test_id,]
  mylist <- list(train = train_data, test = test_data)
  return(mylist)
}

# This function get the vector location back the location of the picture in 3 dimention.  
# Since the data in our picture in 28_resize is (28,28,1,3).
# Here vec must be an vector.  
get_3d_location <- function(vec, size = c(28,28)) {
  vec = vec-1
  loca_3 = vec%/%prod(size)+1
  vec = vec%%prod(size)
  loca_2 = vec%/%size[1]+1
  loca_1 = vec%%size[1]+1
  loca =cbind(loca_1, loca_2, loca_3)
  return(loca)
}
# Try 100 repeats and get average accuracy on testing data. 
accuracy_rf_svm <- matrix(0, ncol = 5, nrow = 3)
colnames(accuracy_rf_svm) = c('Accuracy','1-prescision','1-recall','0-precision','0-recall')
rownames(accuracy_rf_svm) = c('randomforest','svm','logestic')
reps = 100
count = 0

for (i in 1:reps) {
  # Split train and test data sets
  data <- split_train_test(df_flat_img, 0.2)
  # Random Forest
  rffit <- randomForest(data$train[,-1], as.factor(data$train[,1]), 
                        ntree = 2000, mtry = 2000, nodesize = 10)
  accuracy_rf_svm[1,1] = accuracy_rf_svm[1,1] + mean(predict(svmfit, data$test[,-1])==data$test[,1])/reps
  detab <- table(data$test[,1], predict(rffit, data$test[,-1]))
  accuracy_rf_svm[1,2] <- detab[2,2]/sum(detab[,2])/reps + accuracy_rf_svm[1,2]
  accuracy_rf_svm[1,3] <- detab[2,2]/sum(detab[2,])/reps + accuracy_rf_svm[1,3]
  accuracy_rf_svm[1,4] <- detab[1,1]/sum(detab[,1])/reps + accuracy_rf_svm[1,4]
  accuracy_rf_svm[1,5] <- detab[1,1]/sum(detab[1,])/reps + accuracy_rf_svm[1,5]
  # SVM 
  svmfit <- svm(data$train[,-1], as.factor(data$train[,1]), probablity = T, cross = 3,
                type = "C-classification", method = "SVM")
  accuracy_rf_svm[2,1] = accuracy_rf_svm[2,1] + mean(predict(svmfit, data$test[,-1])==data$test[,1])/reps
  detab <- table(data$test[,1], predict(svmfit, data$test[,-1]))
  accuracy_rf_svm[2,2] <- detab[2,2]/sum(detab[,2])/reps + accuracy_rf_svm[2,2]
  accuracy_rf_svm[2,3] <- detab[2,2]/sum(detab[2,])/reps + accuracy_rf_svm[2,3]
  accuracy_rf_svm[2,4] <- detab[1,1]/sum(detab[,1])/reps + accuracy_rf_svm[2,4]
  accuracy_rf_svm[2,5] <- detab[1,1]/sum(detab[1,])/reps + accuracy_rf_svm[2,5]
  # Logistic
  lgmfit <- glm(factor(malignant)~., data=data$train, family = "binomial", method = "glm.fit",maxit=100)
  accuracy_rf_svm[3,1] = accuracy_rf_svm[3,1] + mean(as.numeric(predict(lgmfit, data$test[,-1])>0.5)==data$test[,1])/reps
  detab <- table(data$test[,1], as.numeric(predict(lgmfit, data$test[,-1])>0.5))
  accuracy_rf_svm[3,2] <- detab[2,2]/sum(detab[,2])/reps + accuracy_rf_svm[3,2]
  accuracy_rf_svm[3,3] <- detab[2,2]/sum(detab[2,])/reps + accuracy_rf_svm[3,3]
  accuracy_rf_svm[3,4] <- detab[1,1]/sum(detab[,1])/reps + accuracy_rf_svm[3,4]
  accuracy_rf_svm[3,5] <- detab[1,1]/sum(detab[1,])/reps + accuracy_rf_svm[3,5]
  
  count = count +1
  print(count)
}
View(accuracy_rf_svm)
#######################################################################################
## Logistic Regression
data <- split_train_test(df_flat_img, 0.2)
lgmfit <- glm(factor(malignant)~., data=data$train, family = "binomial", 
              method = "glm.fit",maxit=100)
mean(as.numeric(predict(lgmfit, data$test[,-1])>0.5)==data$test[,1])
 # Selecting Parameters by LASSO
glmfit <- cv.glmnet(as.matrix(data$train[,-1]), factor(data$train[,1]), 
                    family = "binomial",alpha = 1)
mean(as.numeric(predict(glmfit, s = "lambda.min", as.matrix(data$test[,-1]))>0.5)==data$test[,1])
mean(as.numeric(predict(glmfit, s = "lambda.1se", as.matrix(data$test[,-1]))>0.5)==data$test[,1])
 # Checking plot for lambda and tuning
par(mfrow = c(1,2))
plot(glmfit)
plot(glmfit$glmnet.fit, "lambda")
 # min and 1se for lambda
(cf_min <- coef(glmfit, s = "lambda.min")[which(coef(glmfit, s = "lambda.min")!=0),][-1])
(cf_1se <- coef(glmfit, s = "lambda.1se")[which(coef(glmfit, s = "lambda.1se")!=0),][-1])
 # Pixels location for valid ones.
backone_min <- get_3d_location(as.numeric(names(coef(glmfit, s = "lambda.min")[which(coef(glmfit, s = "lambda.min")!=0),])[-1]))
backone_1se <- get_3d_location(as.numeric(names(coef(glmfit, s = "lambda.1se")[which(coef(glmfit, s = "lambda.1se")!=0),])[-1]))
par(mfrow = c(1,2))
plot(backone_min[,1],backone_min[,2],main="lambda_min",
     col=ifelse(cf_min>0,"red","blue"),xlab='',ylab='')
plot(backone_1se[,1],backone_1se[,2],main="lambda_1se",
     col=ifelse(cf_1se>0,"red","blue"),xlab='',ylab='')
#######################################################################################
## Support Vector Mathine
kernels <- c("linear","polynomial","radial","sigmoid")
svmtable <- matrix(0, nrow = 1, ncol = 4)
colnames(svmtable) <- kernels
reps <- 100
t <- 0
for (i in 1:100) {
  data <- split_train_test(df_flat_img, 0.2)
  for (j in 1:4) {
    svmfit <- svm(data$train[,-1], as.factor(data$train[,1]), probablity = T, 
                  cross = 10, type = "C-classification", method = "SVM", kernel=kernels[j])
    svmtable[1,j] <- mean(predict(svmfit, data$test[,-1])==data$test[,1])/reps+svmtable[1,j]
  }
  t <- t+1
  print(t)
}
#######################################################################################
## Random Forest
data <- split_train_test(df_flat_img, 0.2)
rffit <- randomForest(data$train[,-1], as.factor(data$train[,1]), 
                      # Tuning
                      ntree = 2000, mtry = 2000, nodesize = 10)
# Accuracy in train data
mean(rffit$predicted==data$train[,1])
# Accuracy in test data
mean(data$test[,1]==predict(rffit, data$test[,-1]))
# Precision and recall
detab <- table(data$test[,1], predict(rffit, data$test[,-1]))
(precision_1 <- detab[2,2]/sum(detab[,2]))
(recall_1 <- detab[2,2]/sum(detab[2,]))

(precision_1 <- detab[1,1]/sum(detab[,1]))
(recall_1 <- detab[1,1]/sum(detab[1,]))

# Now we need to check importance of pixels and redunce dimentions.
par(mfrow = c(1,1))
varImpPlot(rffit)
# Some more tuning by importance
imp <- rffit$importance
vec <- 1:length(imp)
################# !Threshold! ##
id <- as.vector(imp > 0.12)
imp_vec <- vec[id]
# Get back to 3d location
back_loca <- get_3d_location(imp_vec)
split_bylayer <- split(1:nrow(back_loca),back_loca[,'loca_3'])

# Draw all pixels larger than threshold.
par(mfrow = c(2,2))
plot(back_loca[split_bylayer[[1]],1], back_loca[split_bylayer[[1]],2], 
     xlim = c(-1,29), ylim = c(-1,29), main = "overall", xlab = '', ylab = '',
     col = 'red')
points(back_loca[split_bylayer[[2]],1], back_loca[split_bylayer[[2]],2], 
       col = 'green', pch = 3)
points(back_loca[split_bylayer[[3]],1], back_loca[split_bylayer[[3]],2], 
       col = 'blue', pch = 5)
abline(v = 14, lty = 3)
abline(h = 14, lty = 3)
layer <- c("red","green","blue")
for (i in 1:length(split_bylayer)) {
  plot(back_loca[split_bylayer[[i]],1], back_loca[split_bylayer[[i]],2], 
       xlim = c(-1,29),ylim = c(-1,29),main = paste("layer =", layer[i]), xlab = '', ylab = '',
       col = layer[i])
  abline(v = 14, lty = 3)
  abline(h = 14, lty = 3)
}
# Number of importance pixels.
nrow(back_loca)

# Then we use only importance pixels to build the model.
derffit <- randomForest(data$train[,-1][,id], as.factor(data$train[,1]), 
                        ntree = 2000, mtry = 100, nodesize = 10)
mean((derffit$predicted)==data$train[,1])
mean(data$test[,1]==predict(derffit, data$test[,-1]))

detab <- table(data$test[,1], predict(derffit, data$test[,-1]))
(precision_1 <- detab[2,2]/sum(detab[,2]))
(recall_1 <- detab[2,2]/sum(detab[2,]))

(precision_1 <- detab[1,1]/sum(detab[,1]))
(recall_1 <- detab[1,1]/sum(detab[1,]))
