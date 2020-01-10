import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

fan_channel_1=12
fan_channel_2=32
GPIO.setwarnings(False)
GPIO.setup(fan_channel_1, GPIO.OUT)
GPIO.setup(fan_channel_2, GPIO.OUT)
GPIO.output(fan_channel_2, GPIO.LOW)

pwm=GPIO.PWM(fan_channel_1, 100)

speed=35

isRunning=0

def start():
    pwm.start(0)
    isRunning=1

def fanOn():
    start()
    fanSpeed(speed)
    
def fanOff():
    speed=0
    isRunning=0
    pwm.stop()
    #GPIO.cleanup()
    
def fanSpeed(speed):
    if isRunning==0:
        print('isRunining :', isRunning)
        start()
    pwm.ChangeDutyCycle(speed)
    print(speed)