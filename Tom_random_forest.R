#######################################################################################
# Based data part from file 'create_df_flat_img'
library(imager)
path_to_benign_images = './28_resize/benign/' #Be sure to end with '/'
path_to_malignant_images = './28_resize/malignant/' #Be sure to end with '/'

file_map =  read.csv('original_file_map.csv', stringsAsFactors = FALSE)[,c('file_name','malignant')]

file_name = c()
img = c()

n <- nrow(file_map)


count = 0
for(i in 1:n)
{
  if(file_map[i,'malignant'] == 0)
  {
    path = paste0(path_to_benign_images, file_map[i,'file_name'])
  }
  else
  {
    path = paste0(path_to_malignant_images, file_map[i,'file_name'])
  }
  pre_img <- load.image(path)
  pre_img <- resize(pre_img, 28, 28, 1, 3)
  img = rbind(img, c(pre_img))
  file_name = cbind(file_name, file_map[i,'file_name'])
  
  count = count + 1
  if (mod(count, 10) == 0)
  {
    print(count)
  }
  
}

df_flat_img = data.frame('file_name' = c(file_name), stringsAsFactors = FALSE)
df_flat_img = cbind(df_flat_img, img)

#Adding 'malignant' column.  This is the Response Variable
df_flat_img = merge(file_map, df_flat_img, by = 'file_name')
df_flat_img[,c('file_name')] = NULL
# df_flat_img is the data frame with first column be the malignant identifier. 
#######################################################################################
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

###
# Here I split the data into train and test parts.
data <- split_train_test(df_flat_img, 0.2)
# Check how we split the data
sapply(data, nrow)

###
# Now build a random forest model for all pixels.
library(randomForest)
rffit <- randomForest(data$train[,-1], as.factor(data$train[,1]), 
                      # Tuning
                      ntree = 2000, mtry = 2000, nodesize = 10)
# Accuracy in train data
mean(rffit$predicted==data$train[,1])
# Accuracy in test data
mean(data$test[,1]==predict(rffit, data$test[,-1]))

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
mean(derffit$predicted==data$train[,1])
mean(data$test[,1]==predict(derffit, data$test[,-1]))