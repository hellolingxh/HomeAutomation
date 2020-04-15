#! /usr/bin/python3.7
import sys
sys.path.append('/opt/rpiboard')

import RPi.GPIO as GPIO
import config
from scripts.cctv.control import cctvOn, cctvOff
from scripts.light.control import lightOn, lightOff
from scripts.fan.control import fanOff, fanSpeed
from scripts.shutter.control import shutterMove, shutterStop
from scripts.door.bell.control import bellOn, bellOff, bellCallBack
from scripts.door.lock.control import lock, unlock
from scripts.door.camera.control import cameraOn, cameraOff
from scripts.atmosphere.indoor.control import indoorAtmosphereRead
from scripts.atmosphere.outdoor.control import outdoorAtmosphereRead
import paho.mqtt.client as mqtt
from cloudMain import cloud_main
import _thread
import time

    
print("creating new instance")
client = mqtt.Client(config.MQTT_CLIENT_IDENTIFIER) #create new instance

print("connecting to broker")
client.connect(config.MQTT_BROKER_ADDRESS) #connect to broker

def button_callback(button_channel):
    print('button pressed')
    client.publish("topic/door/bell/control", "on")

def atmosphere_publish(topic, message):
    print("temperature publish", message)
    client.publish(topic, message)

bellCallBack(button_callback)

def on_message(client, userdata, message):
    status = str(message.payload.decode("utf-8"))
    print("message received " , status)
    print("message topic=",message.topic)
    print("message qos=",message.qos)
    print("message retain flag=",message.retain)
    
    if message.topic=='topic/camera/cctv':
        if status=='on':
            print("camera on")
            cctvOn()
        else:
            print("camera off")
            cctvOff()
    elif message.topic=='topic/light/control':
        if status=='on':
            print('light on by WIFI')
            lightOn()
        else:
            print('light off by WIFI')
            lightOff()
    elif message.topic=='topic/fan/control':
        if status=='off':
            print('fan off')
            fanOff()
        elif status.isnumeric():
            print('fan speed adjust')
            fanSpeed(int(status))
    elif message.topic=='topic/shutter/control':
        if status=='stop':
            print('shutter stop')
            shutterStop()
        else:
            print('shutter move to ', status)
            shutterMove(status)
    elif message.topic=='topic/door/camera/control':
        if status=='on':
            print("door camera on")
            cameraOn()
        else:
            print("door camera off")
            cameraOff()
    elif message.topic=='topic/door/lock/control':
        if status=='lock':
            print("door locked")
            lock()
        else:
            print("door unlocked")
            unlock()
    elif message.topic=='topic/indoor/measurement/read':
        if status=='on':
            print("indoor measurement read switch on")
            result = indoorAtmosphereRead()
            atmosphere_publish("topic/indoor/measurement/data", result)
    elif message.topic=='topic/outdoor/measurement/read':
        if status=='on':
            print("outdoor measurement read switch on")
            result = outdoorAtmosphereRead()
            atmosphere_publish("topic/outdoor/measurement/data", result)
            
client.on_message=on_message #attach function to callback
            
def bell():
    while True:
        time.sleep(1)
        if GPIO.input(config.DOORBUTTON_CHANNEL) == False:
            bellOn()
        else:
            bellOff()
        
########################################
def main():
    
    client.loop_start() #start the loop
    print("Subscribing to camera topic","topic/camera/cctv by WIFI")
    client.subscribe("topic/camera/cctv")
    print("Subscribing to ligh topic","topic/light/control by WIFI")
    client.subscribe("topic/light/control")
    print("Subscribing to fan topic","topic/fan/control by WIFI")
    client.subscribe("topic/fan/control")
    print("Subscribing to shutter topic","topic/shutter/control by WIFI")
    client.subscribe("topic/shutter/control")
    print("Subscribing to door camera topic","topic/door/camera/control by WIFI")
    client.subscribe("topic/door/camera/control")
    print("Subscribing to door lock topic","topic/door/lock/control by WIFI")
    client.subscribe("topic/door/lock/control")
    print("Subscribing to indoor temperature and humidity read topic","topic/indoor/measurement/read by WIFI")
    client.subscribe("topic/indoor/measurement/read")
    print("Subscribing to outdoor temperature and humidity read topic","topic/outdoor/measurement/read by WIFI")
    client.subscribe("topic/outdoor/measurement/read")
    
    time.sleep(24*60*60) # wait
    print('time up to stop')
    client.loop_stop() #stop the loop

if __name__ == "__main__":
    try:
        _thread.start_new_thread( main, () )
        _thread.start_new_thread( cloud_main, () )
        _thread.start_new_thread( bell, () )
    except:
        print ("Error: unable to start thread")
    

