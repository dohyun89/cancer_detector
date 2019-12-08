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

temp_path = c()
temp_dim_1 = c()
temp_dim_2 = c()
for (i in df_file$filepath)
{
  temp = load.image(i)
  temp_path = append(temp_path, i)
  temp_dim_1 = append(temp_dim_1, dim(temp)[1])
  temp_dim_2 = append(temp_dim_2, dim(temp)[2])
  
}
df_dim = data.frame("filepath" = temp_path, "dim_1" = temp_dim_1, "dim_2" = temp_dim_2, stringsAsFactors = FALSE)

df_file = merge(df_file, df_dim, by = "filepath")

write.csv(df_file, 'original_file_info.csv', row.names = FALSE)
