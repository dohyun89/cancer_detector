#Libraries
library(imager)
library(dplyr)

path_malignant =  paste0(getwd(),'/Skin Cancer Data/malignant/' ,list.files(path = './Skin Cancer Data/542/malignant', 
                                                                            pattern = '.jpg'))
path_benign = paste0(getwd(),'/Skin Cancer Data/benign/', list.files(path = './Skin Cancer Data/542/benign', 
                                                                    pattern = '.jpg'))

df_file= data.frame("filepath"= c(path_malignant,path_benign), 
                    "malignant" =  c(rep(1,150), rep(0,150)))

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
