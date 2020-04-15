import RPi.GPIO as GPIO
from config import SHUTTER_DIR_CHANNEL_1, SHUTTER_PWM_CHANNEL_2
import time

GPIO.setmode(GPIO.BCM)

GPIO.setwarnings(False)
GPIO.setup(SHUTTER_DIR_CHANNEL_1, GPIO.OUT)
GPIO.setup(SHUTTER_PWM_CHANNEL_2, GPIO.OUT)

speed=70;

pwm=GPIO.PWM(SHUTTER_PWM_CHANNEL_2, speed)

def speedup(direction):
    GPIO.output(SHUTTER_DIR_CHANNEL_1, direction)
    pwm.ChangeDutyCycle(speed)
    
def shutterMove(direction):
    pwm.start(0)
    if direction=='left':
        speedup(GPIO.LOW)
    else:
        speedup(GPIO.HIGH)

def shutterStop():
    pwm.start(0)
    pwm.stop()
    