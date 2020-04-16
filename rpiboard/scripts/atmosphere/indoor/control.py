#! /usr/bin/python3.7
import Adafruit_DHT
from config import INDOOR_DHT_PIN
from scripts.atmosphere.atmosphereData import read
import time

INDOOR_DHT_SENSOR = Adafruit_DHT.AM2302
       
def indoorAtmosphereDataRead():
    return read(INDOOR_DHT_SENSOR, INDOOR_DHT_PIN)
    
    
              