#! /usr/bin/python3.7

import RPi.GPIO as GPIO
from config import DOORBELL_CHANNEL, DOORBUTTON_CHANNEL
import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(DOORBELL_CHANNEL, GPIO.OUT)
GPIO.output(DOORBELL_CHANNEL, GPIO.HIGH)

GPIO.setup(DOORBUTTON_CHANNEL, GPIO.IN, pull_up_down=GPIO.PUD_UP)

#That buzzer is triggered by low-level
def bellOn():
    GPIO.output(DOORBELL_CHANNEL, GPIO.LOW)

def bellOff():
    GPIO.output(DOORBELL_CHANNEL, GPIO.HIGH)

#hen the door button was pressed then let the bell beep.
def bellListenning():
    while True:
        time.sleep(1)
        if GPIO.input(DOORBUTTON_CHANNEL) == False:
            bellOn()
        else:
            bellOff()
    
def bellCallBack(button_callback):
    GPIO.add_event_detect(DOORBUTTON_CHANNEL,GPIO.RISING,callback=button_callback) # Setup event on pin 10 rising edge