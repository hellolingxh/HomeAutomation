#! /usr/bin/python3.7

import RPi.GPIO as GPIO
from config import DOORBELL_CHANNEL, DOORBUTTON_CHANNEL

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(DOORBELL_CHANNEL, GPIO.OUT)
GPIO.output(DOORBELL_CHANNEL, GPIO.HIGH)

print(GPIO.input(DOORBELL_CHANNEL))

GPIO.setup(DOORBUTTON_CHANNEL, GPIO.IN, pull_up_down=GPIO.PUD_UP) # Set pin 10 to be an input pin and set initial value to be pul 

def bellOn():
    GPIO.output(DOORBELL_CHANNEL, GPIO.LOW)

def bellOff():
    GPIO.output(DOORBELL_CHANNEL, GPIO.HIGH)
    
def bellCallBack(button_callback):
    GPIO.add_event_detect(DOORBUTTON_CHANNEL,GPIO.RISING,callback=button_callback) # Setup event on pin 10 rising edge