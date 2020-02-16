import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

dir_channel_1=4
pwm_channel_2=13

GPIO.setwarnings(False)
GPIO.setup(dir_channel_1, GPIO.OUT)
GPIO.setup(pwm_channel_2, GPIO.OUT)

pwm=GPIO.PWM(pwm_channel_2, 100)

speed=100;

def speedup(direction):
    GPIO.output(dir_channel_1, direction)
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
    