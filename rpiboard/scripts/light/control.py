#! /usr/bin/python3.7

import RPi.GPIO as GPIO
from config import LIGHT_RELAY_CHANNEL

GPIO.setmode(GPIO.BCM)

GPIO.setwarnings(False)
GPIO.setup(LIGHT_RELAY_CHANNEL, GPIO.OUT)

def lightOn():
    GPIO.output(LIGHT_RELAY_CHANNEL, GPIO.HIGH)

def lightOff():
    GPIO.output(LIGHT_RELAY_CHANNEL, GPIO.LOW)
    #GPIO.cleanup()
    

