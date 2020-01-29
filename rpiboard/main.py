#! /usr/bin/python3.7
import sys
sys.path.append('/opt/rpiboard')

from scripts.camera.control import cameraOn, cameraOff
from scripts.light.control import lightOn, lightOff
from scripts.fan.control import fanOn, fanOff, fanSpeed
import paho.mqtt.client as mqtt

import time
############

def on_message(client, userdata, message):
    status = str(message.payload.decode("utf-8"))
    print("message received " , status)
    print("message topic=",message.topic)
    print("message qos=",message.qos)
    print("message retain flag=",message.retain)
    
    if message.topic=='topic/camera/cctv':
        if status=='on':
            print("camera on")
            cameraOn()
        else:
            print("camera off")
            cameraOff()
    elif message.topic=='topic/light/control':
        if status=='on':
            print('light on')
            lightOn()
        else:
            print('light off')
            lightOff()
    elif message.topic=='topic/fan/control':
        if status=='off':
            print('fan off')
            fanOff()
        elif status.isnumeric():
            print('fan speed adjust')
            fanSpeed(int(status))
                    
    
########################################
def main():
    broker_address="192.168.8.1"
    #fanOn()
    print("creating new instance")
    client = mqtt.Client("P1") #create new instance
    client.on_message=on_message #attach function to callback
    print("connecting to broker")
    client.connect(broker_address) #connect to broker
    client.loop_start() #start the loop
    print("Subscribing to camera topic","topic/camera/cctv")
    client.subscribe("topic/camera/cctv")
    print("Subscribing to ligh topic","topic/light/control")
    client.subscribe("topic/light/control")
    print("Subscribing to fan topic","topic/fan/control")
    client.subscribe("topic/fan/control")
    time.sleep(24*60*60) # wait
    print('time up to stop')
    client.loop_stop() #stop the loop

if __name__ == "__main__":
    main()
    print('The program has already exited')
    GPIO.cleanup()

