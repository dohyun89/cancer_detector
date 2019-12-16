import os
import glob
import cv2 as cv

def resize_imgs(file_path, resized_path, dim):
    if os.path.isdir(resized_path) == False:
        os.makedirs(resized_path)

    for j in glob.glob(file_path + '/*.jpg'):
        img = cv.imread(j)
        resized = cv.resize(img, dim)
        resized_full_path = os.path.join(resized_path, os.path.split(j)[1])
        cv.imwrite(resized_full_path,resized)

    