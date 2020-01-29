# This is a project for centre console of the home automation

# OperWrt router configuration
- username
    - admin
- password
    - 1q"W3e$R
- ssh login
    - ssh root@192.168.8.1
    - password 1q"W3e$R

# OperWrt Operating system
## install Python3
- to run
```
opkg update
opkg install python3 -d ram
export PAHT=$PATH:/tmp/usr/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/usr/lib
```
## install Python3-pip
- to run 
```
opkg update
opkg install python3-pip -d ram
export PATH=$PATH:/tmp/usr/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/usr/lib
```

## install dependency
- install paho-mqtt
```
python3 -m pip install paho-mqtt

// pip3 install paho-mqtt 
// should occur error:
// ModuleNotFoundError: No module named 'pip'
```

## Errors with Solutions
- Fatal Python error: Py_Initialize: Unable to get the locale encoding
```
export PYTHONPATH=/tmp/usr/lib/python3.6
```
