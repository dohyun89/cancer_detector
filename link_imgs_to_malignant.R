#Libraries
library(imager)
library(dplyr)

malignant_name = list.files(path = './Skin Cancer Data/542/malignant', pattern = '.jpg')
benign_name = list.files(path = './Skin Cancer Data/542/benign', pattern = '.jpg')
path_malignant =  paste0(getwd(),'/Skin Cancer Data/542/malignant/' , malignant_name)
path_benign = paste0(getwd(),'/Skin Cancer Data/542/benign/', benign_name)

df_file= data.frame("filepath"= c(path_malignant, path_benign), 
                    "file_name" = c(malignant_name, benign_name),
                    "malignant" =  c(rep(1,150), rep(0,150)), stringsAsFactors = FALSE)

write.csv(df_file, 'original_file_map.csv', row.names = FALSE)
