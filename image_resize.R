path_malignant =  paste0(getwd(),'./Skin Cancer Data/542/malignant/' ,list.files(path = './Skin Cancer Data/542/malignant', 
                                                                            pattern = '.jpg'))
path_benign = paste0(getwd(),'./Skin Cancer Data/542/benign/', list.files(path = './Skin Cancer Data/542/benign', 
                                                                    pattern = '.jpg'))

df_file= data.frame("filepath"= c(path_malignant,path_benign), 
                    "malignant" =  c(rep(1,150), rep(0,150)), stringsAsFactors = FALSE)
                    
#source("http://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(imager)


for (i in 1:150){
  
  image=load.image(df_file[i,1])

  img_res=resize(image,300,300)
  
  imager::save.image(img_res,paste0("C:/Users/krish/Desktop/grp_proj_542/300_resize/malignant/" ,file_map$file_name[i]))
  
  
}


# width and height of the original image
dim(x)[1:2]

# scale to a specific width and height
y <- resize(x, w = 200, h = 100)

# scale by 50%; the height is determined automatically so that
# the aspect ratio is preserved
y <- resize(x, dim(x)[1]/2)

# show the scaled image
display(y)

# extract the pixel array
z <- imageData(y)

# or
z <- as.array(y)