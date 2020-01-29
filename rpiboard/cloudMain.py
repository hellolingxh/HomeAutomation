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
            print('light on')
            lightOn()
        else:
            print('light off')
            lightOff()

def main():
    broker_address="b-64160930-1437-447e-a084-0f0e5ed98c68-1.mq.eu-west-1.amazonaws.com"
    print('connecting ',broker_address)
    client = mqtt.Client('Console')
    client.username_pw_set('mqtt', 'LOvehuihui1314')
    client.on_connect=on_connect
    client.on_message=on_message
    client.tls_set('/home/pi/cert/AmazonRootCA1.pem')
    client.connect(broker_address, port=8883)
    client.loop_start() #start the loop
    time.sleep(24*60*60) # wait
    lient.loop_stop() #stop the loop




if __name__ == "__main__":
    main()