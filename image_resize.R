path_malignant =  paste0(getwd(),'/Skin Cancer Data/malignant/' ,list.files(path = './Skin Cancer Data/542/malignant', 
                                                                            pattern = '.jpg'))
path_benign = paste0(getwd(),'/Skin Cancer Data/benign/', list.files(path = './Skin Cancer Data/542/benign', 
                                                                    pattern = '.jpg'))

df_file= data.frame("filepath"= c(path_malignant,path_benign), 
                    "malignant" =  c(rep(1,150), rep(0,150)))
                    
#source("http://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(imager)

image=load.image('C:/Users/krish/Desktop/grp_proj_542/Skin Cancer Data/542/malignant/ISIC_0000022.jpg')
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