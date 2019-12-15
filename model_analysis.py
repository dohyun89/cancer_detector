# -*- coding: utf-8 -*-
"""
Created on Sun Dec 15 00:48:49 2019

@author: krish
"""

import pandas as pd
import cv2 as cv
import numpy as np
import os

#following paths need to be pointing to the location of the data

ben_seg_path='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/Segmented/benign'
malig_seg_path='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/Segmented/malignant'

ben_path='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/300_resize/benign'
malig_path='C:/Users/krish/Desktop/grp_proj_542/cancer_detector/300_resize/malignant'



def img2df(img_path_id):
    
    os.chdir(img_path_id)
    file_ids=os.listdir(img_path_id)
    x_img = np.array([np.array(cv.imread(file_ids[i])) for i in range(len(file_ids))])
    
    pixels = x_img.flatten().reshape(len(file_ids), 270000) #(150,300*300*3)
    
    return(pixels)

    
x_ben=img2df(ben_path)
y_ben=np.zeros((150,1), dtype=int)

x_malig=img2df(malig_path)
y_malig=np.ones((150,1), dtype=int)

X=np.append(x_ben,x_malig, axis=0)
y=np.append(y_ben,y_malig, axis=0)

from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, \
                                                    random_state=1)

from sklearn.linear_model import LogisticRegression
clf = LogisticRegression().fit(X_train, y_train)

y_pred=clf.predict(X_test)

from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score

print(classification_report(y_test, y_pred))
print(confusion_matrix(y_test, y_pred))
print(accuracy_score(y_test, y_pred))


from sklearn.ensemble import ExtraTreesClassifier
from sklearn.feature_selection import SelectFromModel
clf_feat = ExtraTreesClassifier(n_estimators=50)
clf_feat = clf_feat.fit(X, y)
clf_feat.feature_importances_  
model = SelectFromModel(clf_feat, prefit=True)
X_new = model.transform(X)

X_train, X_test, y_train, y_test = train_test_split(X_new, y, test_size=0.2, \
                                                    random_state=10)

from sklearn.model_selection import cross_val_score
from sklearn import svm
clf_svm = svm.SVC(kernel='rbf', C=1)


