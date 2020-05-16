#!/bin/bash

# usage: ./train.sh <data_file> <config_file> <

path="/content/drive/My\ Drive/COLAB/Yolov4/"
dir=$(date +'%m_%d_%y')

mkdir "${path}train_${dir}"

touch "${path}info.txt"
echo "$(date)" >> "${path}info.txt"
echo 

echo "starting train..."

chmod +x darknet
./darknet detector train vant_dataset.data custom_configs/yolov4-416.cfg yolov4.conv.137 -dont_show > /content/drive/My\ Drive/COLAB/Yolov4/.txt

