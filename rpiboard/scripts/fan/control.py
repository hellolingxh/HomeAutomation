import RPi.GPIO as GPIO
from config import FAN_PWM_CHANNEL

GPIO.setmode(GPIO.BCM)

GPIO.setwarnings(False)
GPIO.setup(FAN_PWM_CHANNEL, GPIO.OUT)

pwm=GPIO.PWM(FAN_PWM_CHANNEL, 100)

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
    
def fanSpeed(speed):
    if isRunning==0:
        print('isRunining :', isRunning)
        start()
    pwm.ChangeDutyCycle(speed)
    print(speed)