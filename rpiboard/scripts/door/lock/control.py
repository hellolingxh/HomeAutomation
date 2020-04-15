#! /usr/bin/python3.7

import RPi.GPIO as GPIO
from config import LOCK_CHANNEL

GPIO.setmode(GPIO.BCM)

GPIO.setwarnings(False)
GPIO.setup(LOCK_CHANNEL, GPIO.OUT)

def lock():
    GPIO.output(LOCK_CHANNEL, GPIO.LOW)

def unlock():
    GPIO.output(LOCK_CHANNEL, GPIO.HIGH)