# df_flat_img is the data frame with first column be the malignant identifier. 
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
data <- split_train_test(df_flat_img, 0.1)
sapply(data, nrow)