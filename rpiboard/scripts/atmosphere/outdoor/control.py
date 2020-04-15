#! /usr/bin/python3.7
import Adafruit_DHT
from config import OUTDOOR_DHT_PIN
import time

OUTDOOR_DHT_SENSOR = Adafruit_DHT.AM2302
       
def outdoorAtmosphereRead():
    humidity, temperature = Adafruit_DHT.read_retry(OUTDOOR_DHT_SENSOR, OUTDOOR_DHT_PIN)
    
    if humidity is not None and temperature is not None:
        print("Temp={0:0.1f}*C  Humidity={1:0.1f}%".format(temperature, humidity))
        return "{0:0.1f}|{1:0.1f}".format(temperature, humidity)
    else:
        print("Failed to retrieve data from humidity sensor")
    
    
              
