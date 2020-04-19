#! /usr/bin/python3.7
import os

def cameraOn():
    os.system("nohup mjpg_streamer -i 'input_raspicam.so -d /dev/video0' -o 'output_http.so -p 8088 -w /tmp/www' &")

def cameraOff():
    os.system('pkill mjpg_streamer')