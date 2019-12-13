# install USB camera
- https://www.raspberrypi.org/documentation/usage/webcams/README.md
- sudo apt install fswebcam  //install the web camera driver
- sudo usermod -a -G video pi  // add the user ino video group
- fswebcam image.jpg  // driver the amera to take a picture
- xdg-open image.jpg // open the picture file
