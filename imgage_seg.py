# -*- coding: utf-8 -*-
"""
Created on Wed Dec 11 18:25:15 2019

@author: krish
"""

import numpy as np
import cv2
from matplotlib import pyplot as plt
import matplotlib.image as mpimg
import pandas as pd

import os


os.chdir('C:/Users/krish/Desktop/grp_proj_542/cancer_detector')

file_id=pd.read_csv('original_file_map.csv')

benign_id=file_id['file_name'][0:150]
malig_id=file_id['file_name'][150:300]

benign_in='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/300_resize/benign'

malig_in='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/300_resize/malignant'


def img_seg(file_id,inp_path,out_path):
    
    
    for img_id in file_id:
        
        os.chdir(inp_path)

    
        img = cv2.imread(img_id)
        #plt.imshow(img)
        gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
        #plt.imshow(gray)

        ret, thresh = cv2.threshold(gray,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)

        thresh2=thresh/255
        thresh2=thresh2.astype(int)
        thresh2=thresh2[:,:,None]

        seg_img=thresh2*img
        os.chdir(out_path)
        cv2.imwrite(img_id, seg_img)
        #plt.imshow(seg_img)

    


def img_thresh(file_id):
    img = cv2.imread(str(file_id))
        #plt.imshow(img)
    gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
        #plt.imshow(gray)

    ret, thresh = cv2.threshold(gray,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
    
    return thresh
    




benign_out='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/Segmented/benign'
    
malig_out='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/Segmented/malignant'

img_seg(benign_id,benign_in,benign_out)
img_seg(malig_id,malig_in,malig_out)


    
