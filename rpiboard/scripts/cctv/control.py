#! /usr/bin/python3.7

import os

def cctvOn():
    os.system("nohup mjpg_streamer -i 'input_uvc.so -r 640x480 -f 20' -o 'output_http.so -p 8080 -w /tmp/www' &")

def cctvOff():
    os.system('pkill mjpg_streamer')
