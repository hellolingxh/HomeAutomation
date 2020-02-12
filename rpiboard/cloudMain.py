#! /usr/bin/python3.7

import sys
sys.path.append('/opt/rpiboard')

from scripts.light.control import lightOn, lightOff
import paho.mqtt.client as mqtt

import time

def on_connect(client, userdata, flags, rc):
    client.subscribe(topic='topic/light/control')
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
 
def cloud_main():
    print('test...')
    broker_address="b-ddb6ba7b-55f1-4ad2-b3c9-7754a11843ac-1.mq.eu-west-1.amazonaws.com"
    print('connecting ',broker_address)
    client = mqtt.Client('Console')
    client.username_pw_set('mqtt', '1qaz@WSX3edc')
    client.on_connect=on_connect
    client.on_message=on_message
    client.tls_set('/home/pi/cert/AmazonRootCA1.pem')
    client.connect(broker_address, port=8883)
    print("Subscribing to ligh topic","topic/light/control by INTERNET")
    client.publish('topic/light/control', 'on')
    client.loop_start() #start the loop
    time.sleep(24*60*60) # wait
    lient.loop_stop() #stop the loop