#!/bin/bash

dir=$(date +'%m_%d_%y')

mkdir "train_${dir}"
mv backup/* "train_${dir}/"
mv "train_${dir}/" /content/drive/My\ Drive/COLAB/Yolov4/
