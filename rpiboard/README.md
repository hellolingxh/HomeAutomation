# This is a project for raspberry PI functionalities.

# install USB camera
- https://www.raspberrypi.org/documentation/usage/webcams/README.md
- sudo apt install fswebcam  //install the web camera driver
- sudo usermod -a -G video pi  // add the user ino video group
- fswebcam image.jpg  // driver the amera to take a picture
- xdg-open image.jpg // open the picture file

# install mjpg-streamer
- The source code in github https://github.com/jacksonliam/mjpg-streamer.git
- The commands:
```
cd mjpg-streamer-experimental/
sudo apt-get install gcc g++
sudo apt-get install cmake
make
sudo make install
mkdir /tmp/www
```
- To run the mjpg-streamer
  - mjpg-stream -i 'input-uvc.so' -o 'output-http.so -w /tmp/www'

Problem Solved
RPI 4 unable to connect to WiFi.
https://www.raspberrypi.org/forums/viewtopic.php?t=247982
There is a conflict between wifi and low screen resolution.

