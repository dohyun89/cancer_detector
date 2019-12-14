## You will need original_file_map.csv (I think I had it originally named original_file_map.csv) 
## which should contain your local filepath of the original pictures.
## If you do not have it, please run `link_imgs_to_malignant.R`  to create the file.

library(OpenImageR)

file_map =  read.csv('original_file_map.csv', stringsAsFactors = FALSE, row.names = 1)
desired_dimension = '300x300!' ##need the exclaimation mark if the scale cannot be preserved
benign_path_to_save = './300_resize/benign/'
malignant_path_to_save = './300_resize/malignant/'
pic_format = 'jpg'

for (file_path in file_map$filepath)
{
  org_img = image_read(file_path)
  file_name = file_map[file_map$filepath == file_path,]$file_name
  resized_img = image_scale(org_img, desired_dimension)
  if (file_map[file_map$filepath == file_path,]$malignant == 0)
  {
    image_write(resized_img, path = paste0(benign_path_to_save, file_name), format = pic_format)
  }else
  {
    image_write(resized_img, path = paste0(malignant_path_to_save, file_name), format = pic_format)
  }
  
}
