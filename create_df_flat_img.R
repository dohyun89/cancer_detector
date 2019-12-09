## This module will read the resized images, and create a dataframe
## with flattened images as a row
## It is recommended to set your working directory to the source code location.

path_to_benign_images = './resize/benign/' #Be sure to end with '/'
path_to_malignant_images = './resize/malignant/' #Be sure to end with '/'

file_map =  read.csv('original_file_map.csv', stringsAsFactors = FALSE)
file_map = file_map[,-1]
file_map[ , c('filepath','dim_1', 'dim_2')] = NULL
file_name = c()
img = c()



count = 0
for(i in file_map$file_name)
{
  if(file_map[file_map$file_name ==i,]$malignant == 0)
  {
    path = paste0(path_to_benign_images, i)
  }else
  {
    path = paste0(path_to_malignant_images, i)
  }
  img = rbind(img, c(load.image(path)) )
  file_name = cbind(file_name,i)
  
  count = count +1
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

write.csv(df_flat_img, 'df_flat_img.csv')
