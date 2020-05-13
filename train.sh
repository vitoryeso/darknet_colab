#!/bin/bash

mkdir backup
chmod +x darknet
./darknet detector train vant_dataset.data custom_configs/yolov4-416.cfg yolov4.conv.137

