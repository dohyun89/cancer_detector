# -*- coding: utf-8 -*-
"""
Created on Thu Dec 12 01:28:14 2019

@author: krish
"""
import cv2 
import numpy as np
import pandas as pd
import os
from ABCD_feat_func import extract


os.chdir('C:/Users/krish/Desktop/grp_proj_542/cancer_detector')

file_id=pd.read_csv('original_file_map.csv')

benign_id=file_id['file_name'][0:150]
malig_id=file_id['file_name'][150:300]

benign_in='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/300_resize/benign'
benign_out='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/contour/benign'

malig_in='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/300_resize/malignant'
malig_out='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/contour/malignant'


columns=['area','centroid','perimeter','B','D1','D2','A1','A2']

def FindMaxLength(lst): 
    maxList = max(lst, key = len) 
     
    return maxList


df_malign=pd.DataFrame(index=malig_id,columns=columns)
df_benign=pd.DataFrame(index=benign_id,columns=columns)

for img_id in benign_id:
    
    os.chdir(benign_in)
    img = cv2.imread(img_id)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    ret, thresh = cv2.threshold(gray,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
    contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    
    cnt = FindMaxLength(contours)

    cnt_plot=cv2.drawContours(img, [cnt],0, (0,255,0), 2)
    os.chdir(benign_out)
    cv2.imwrite(img_id, cnt_plot)

   # plt.imshow(cnt_plot)    
    feat=extract(img,thresh,cnt)
    
    if(feat!={}):
    
        df_benign.loc[img_id]['area']=feat[0]['area']
        df_benign.loc[img_id]['centroid']=feat[0]['centroid']
        df_benign.loc[img_id]['perimeter']=feat[0]['perimeter']
        df_benign.loc[img_id]['B']=feat[0]['B']
        df_benign.loc[img_id]['D1']=feat[0]['D1']
        df_benign.loc[img_id]['D2']=feat[0]['D2']
        df_benign.loc[img_id]['A1']=feat[0]['A1']
        df_benign.loc[img_id]['A2']=feat[0]['A2']







    
    


        #plt.imshow(img)
contours, hierarchy = cv2.findContours(thresh,1, 2)

cont_2=cv2.drawContours(img, contours, -1, (0,255,0), 3)




