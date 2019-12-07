path_malignant =  paste0(getwd(),'/Skin Cancer Data/malignant/' ,list.files(path = './Skin Cancer Data/malignant', 
                                                                            pattern = '.jpg'))
path_benign = paste0(getwd(),'/Skin Cancer Data/benign', list.files(path = './Skin Cancer Data/benign', 
                                                                    pattern = '.jpg'))

df_file= data.frame("filepath"= c(path_malignant,path_benign), 
                    "malignant" =  c(rep(1,150), rep(0,150))
)