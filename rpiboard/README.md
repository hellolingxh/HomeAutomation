# This is a project for raspberry PI functionalities.

RPI 4 unable to connect to WiFi.
https://www.raspberrypi.org/forums/viewtopic.php?t=247982
There is a conflict between wifi and low screen revolution.

Had the same problem with Raspi 4B.
Problem was dependent on screen resolution (!!). 
With 1920x1080, wlan0 became disconnected after it was ok at lower screen resolutions. Was in 2.4GHz band.
After turning on 5GHz in the router and going into the network preferences (right click the network icon top right on screen) and SSID ... and checking "automatically configure options" the connection remains stable (so far :D ).
