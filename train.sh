#!/bin/bash

# usage: ./train.sh <data_file> <config_file> <initial_weights>

chmod +x darknet

path="/content/drive/My Drive/COLAB/Yolov4/"
# getting only the cfg name
IFS='/'
read -ra STRS <<< "$2"
IFS='.'
read -ra STRS2 <<< "${STRS[-1]}"
cfg=${STRS[0]}
IFS=' '

dir="${path}train_${cfg}"
if [ "$3" == "" ]; then
    num_trains=1
    mkdir "${dir}" 
    mkdir "${dir}/weights"
    mkdir "${dir}/logs"
    touch "${dir}/info.txt"
    echo "train ${num_trains}" >> "${dir}/info.txt"
    echo >> "${dir}/info.txt" 
    echo "$(date)" >> "${dir}/info.txt"
    echo >> "${dir}/info.txt"
    echo "config: $2" >> "${dir}/info.txt"
    echo >> "${dir}/info.txt"
    wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137
    ./darknet detector train "$1" "$2" yolov4.conv.137 -dont_show > "${dir}/logs/${num_trains}_log.txt"
else
    num_trains=$(ls "${dir}/logs/" | grep -i "log" | wc -l)
    num_trains= "$num_trains + 1"
    echo "train ${num_trains}" >> "${dir}/info.txt"
    echo >> "${dir}/info.txt" 
    echo "$(date)" >> "${dir}/info.txt"
    echo >> "${dir}/info.txt"
    ./darknet detector train "$1" "$2" "$3" -dont_show > "${dir}_${num_trains}_log.txt"
fi    



