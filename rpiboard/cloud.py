#! /usr/bin/python3.7

import sys
sys.path.append('/opt/rpiboard')

from scripts.light.control import lightOn, lightOff
import paho.mqtt.client as mqtt
from config import AWS_ACTIVEMQ_HOST, AWS_ACTIVEMQ_USER, AWS_ACTIVEMQ_PASSWORD, AWS_ACTIVEMQ_PORT

import time

def on_message(client, userdata, message):
    status = str(message.payload.decode("utf-8"))
    print("message received " , status)
    print("message topic=",message.topic)
    print("message qos=",message.qos)
    print("message retain flag=",message.retain)
    
    if message.topic=='topic/light/control':
        if status=='on':
            print('light on by INTERNET')
            lightOn()
        else:
            print('light off by INTERNET')
            lightOff()
 
def main():
    
    print('connecting ',AWS_ACTIVEMQ_HOST)
    client = mqtt.Client('RPi')
    client.username_pw_set(AWS_ACTIVEMQ_USER, AWS_ACTIVEMQ_PASSWORD)
    client.on_message=on_message
    client.tls_set('/home/pi/cert/AmazonRootCA1.pem')
    client.connect(AWS_ACTIVEMQ_HOST, port=AWS_ACTIVEMQ_PORT)
    print("Subscribing to ligh topic","topic/light/control by INTERNET")
    client.subscribe(topic='topic/light/control')
    client.loop_start() #start the loop
    time.sleep(24*60*60) # wait
    client.loop_stop() #stop the loop

