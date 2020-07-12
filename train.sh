#!/bin/bash

# usage: ./train.sh <data_file> <config_file> <initial_weights>

chmod +x darknet

path="/content/drive/My Drive/COLAB/Yolov4/"
# getting only the cfg name
IFS='/'
read -ra STRS <<< "$2"
IFS='.'
read -ra STRS2 <<< "${STRS[-1]}"
cfg=${STRS2[0]}
IFS=' '
tiny='tiny'
dir="${path}train_${cfg}"

if [ "$3" == "" ]; then
    assert=$(ls "${dir}/logs/" | grep -i "log" | wc -l)
    if [ ${assert} == 0 ]; then
        num_trains=1
        mkdir "${dir}" 
        mkdir "${dir}/weights"
        mkdir "${dir}/logs"
        touch "${dir}/info.txt"
        echo "train ${num_trains}:">> "${dir}/info.txt"
        echo "  date: $(date)" >> "${dir}/info.txt"
        echo "  config: ${cfg}" >> "${dir}/info.txt"
        echo >> "${dir}/info.txt"
        if [[ $STR2 == *"$tiny"* ]]; then
            wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.conv.29
            ./darknet detector train "$1" "$2" yolov4-tiny.conv.29 -dont_show > "${dir}"/logs/"${num_trains}"_log.txt 
        else
            wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137
            ./darknet detector train "$1" "$2" yolov4.conv.137 -dont_show > "${dir}"/logs/"${num_trains}"_log.txt 
        fi
    else
        echo "O treinamento dessa configuração ja foi iniciado, pfvr tente continuar de onde parou"
    fi
else
    num_trains=$(ls "${dir}/logs/" | grep -i "log" | wc -l)
    prov=1
    num_trains=$(($num_trains + $prov))
    echo "train ${num_trains}:" >> "${dir}/info.txt"
    echo "  date: $(date)" >> "${dir}/info.txt"
    echo "  config: ${cfg}" >> "${dir}/info.txt"
    echo >> "${dir}/info.txt"
    ./darknet detector train "$1" "$2" "$3" -dont_show > "${dir}"/logs/"${num_trains}"_log.txt
fi    



