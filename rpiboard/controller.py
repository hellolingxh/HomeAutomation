#! /usr/bin/python3.7
import sys
from signal import pause
sys.path.append('/opt/rpiboard')

from localMain import main as localMain
from cloudMain import main as cloudMain
from scripts.door.bell.control import bellListenning
       
import _thread

if __name__ == "__main__":
    
    try:
        _thread.start_new_thread( localMain, () )
        _thread.start_new_thread( cloudMain, () )
        _thread.start_new_thread( bellListenning, () )
        pause()
    except:
        print ("Error: unable to start thread")
    

