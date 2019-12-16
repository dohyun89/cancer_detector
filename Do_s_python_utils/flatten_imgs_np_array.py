import numpy as np
import os
import glob
import cv2 as cv

def flatten_imgs_np_array(file_path):
    '''This function will output flattened numpy array of all images in the folder as X.
    It will also output the response numpy array as y.
    Be sure to have the folder structure such that:
            file_path
                |_ benign
                |_ malignant'''
    X = list()
    y = list()
    for i in os.listdir(file_path):
        for j in glob.glob(os.path.join(file_path,i) +'/*.jpg'):
            img = cv.imread(j)
            X.append(img.flatten())
            if i == 'benign':
                y.append(0)
            else:
                y.append(1)

    return (np.array(X),np.array(y))
