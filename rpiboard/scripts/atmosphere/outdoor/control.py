#! /usr/bin/python3.7
import Adafruit_DHT
from config import OUTDOOR_DHT_PIN
from scripts.atmosphere.atmosphereData import read
import time

OUTDOOR_DHT_SENSOR = Adafruit_DHT.AM2302
       
def atmosphereDataRead():
    return read(OUTDOOR_DHT_SENSOR, OUTDOOR_DHT_PIN)
    
    
              
