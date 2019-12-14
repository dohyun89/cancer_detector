library(imager)

malignant_name = list.files(path = './Skin Cancer Data/542/malignant', pattern = '.jpg')
benign_name = list.files(path = './Skin Cancer Data/542/benign', pattern = '.jpg')
path_malignant =  paste0(getwd(),'/Skin Cancer Data/542/malignant/' , malignant_name)
path_benign = paste0(getwd(),'/Skin Cancer Data/542/benign/', benign_name)

df_file= data.frame("filepath"= c(path_malignant, path_benign), 
                    "file_name" = c(malignant_name, benign_name),
                    "malignant" =  c(rep(1,150), rep(0,150)), stringsAsFactors = FALSE)

library(EBImage)

fknn <- function(X,Xp,cl,k=1)
{
  out <- nabor::knn(X,Xp,k=k)
  cl[as.vector(out$nn.idx)] %>% matrix(dim(out$nn.idx)) %>% rowMeans
}

im= load.image('C:/Users/krish/Desktop/grp_proj_542/cancer_detector/Skin Cancer Data/542/malignant/ISIC_0000022.jpg')

#image= readImage('C:/Users/krish/Desktop/grp_proj_542/cancer_detector/Skin Cancer Data/542/malignant/ISIC_0000022.jpg')

fg <- c(550,600,570,620 )
#Background
bg <- c(0,   0, 20,  20 )

px.fg <- ((Xc(im) %inr% fg[c(1,3)]) & (Yc(im) %inr% fg[c(2,4)]))
px.bg <- ((Xc(im) %inr% bg[c(1,3)]) & (Yc(im) %inr% bg[c(2,4)]))

plot(im)
highlight(px.fg)
highlight(px.bg,col="blue")

im.lab <- sRGBtoLab(im)
cvt.mat <- function(px) matrix(im.lab[px],sum(px)/3,3)

fgMat <- cvt.mat(px.fg)
bgMat <- cvt.mat(px.bg)
labels <- c(rep(1,nrow(fgMat)),rep(0,nrow(bgMat)))
library(nabor)
testMat <- cvt.mat(px.all(im))
out <- fknn(rbind(fgMat,bgMat),testMat,cl=labels,k=5)
msk <- as.cimg(rep(out,3),dim=dim(im))
plot(msk)
plot(im*msk)


y = distmap(image)

display(normalize(y), title='Distance map')

w = watershed(y, tolerance=10,ext=1)
display(normalize(w), title='Watershed')


