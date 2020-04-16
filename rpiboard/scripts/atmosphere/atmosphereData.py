#! /usr/bin/python3.7
import Adafruit_DHT
import time

       
def read(DHT_SENSOR, DHT_PIN):
    humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
    
    if humidity is not None and temperature is not None:
        print("Temp={0:0.1f}*C  Humidity={1:0.1f}%".format(temperature, humidity))
        return "{0:0.1f}|{1:0.1f}".format(temperature, humidity)
    else:
        print("Failed to retrieve data from the sensor")
    
    
              
