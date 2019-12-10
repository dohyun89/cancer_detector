library(e1071)
df_flat_img = read.csv('df_flat_img.csv',row.names = 1)
df_x = df_flat_img[,-1]
df_y = df_flat_img[,c('malignant')]

train_idx = sample(1:300,240)


#PCA
x_pca = prcomp(df_x, center = TRUE, scale = TRUE)
x_pca_50 = x_pca$x[,1:50]
df_pca_50 = as.data.frame(cbind(x_pca_50, df_y))
colnames(df_pca_50)[colnames(df_pca_50)=='df_y'] = 'y'

train_pca = df_pca_50[train_idx,]
test_pca = df_pca_50[-train_idx,]


#logistic
log_reg = glm(y~., family = binomial, data = train_pca, method = 'glm.fit')

reg_pred_train = predict(log_reg, type = 'response')

reg_pred_train  = ifelse(y_hat >=0.5, 1,0)
table(reg_pred_train , train_pca$y)


#logistic regression perf
reg_pred_test = predict(log_reg, test_pca, type = 'response')
reg_pred_test = ifelse(y_hat >=0.5, 1, 0)
table(reg_pred_test, test_pca$y)


#Need factor not numeric
train_pca$y = factor(train_pca$y, levels = c(0,1))
test_pca$y = factor(test_pca$y, levels = c(0,1))

#SVM
svm_clf = svm(y~.,
              train_pca,
              type = 'C-classification',
              kernel = 'linear')

svm_pred_train  = predict(svm_clf, train_pca)

table(train_pca$y, svm_pred_train) #80%

svm_pred_test = predict(svm_clf, test_pca)
table(test_pca$y, svm_pred_test) #7%0