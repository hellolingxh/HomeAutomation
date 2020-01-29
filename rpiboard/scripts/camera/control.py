#! /usr/bin/python3.7

import os

def cameraOn():
    os.system("nohup mjpg_streamer -i 'input_uvc.so -r 640x480 -f 20' -o 'output_http.so -w /tmp/www' &")

def cameraOff():
    os.system('pkill mjpg_streamer')
