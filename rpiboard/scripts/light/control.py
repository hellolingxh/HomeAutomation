#! /usr/bin/python3.7

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

relay_channel=21
GPIO.setwarnings(False)
GPIO.setup(relay_channel, GPIO.OUT)

#for i in range(10):
    #GPIO.output(relay_channel, GPIO.LOW)
    #time.sleep(1)
    #GPIO.output(relay_channel, GPIO.HIGH)
    #time.sleep(1)

def lightOn():
    GPIO.output(relay_channel, GPIO.HIGH)

def lightOff():
    GPIO.output(relay_channel, GPIO.LOW)
    
#GPIO.cleanup()
    

