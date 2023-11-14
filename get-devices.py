import sys

f = open("/proc/bus/input/devices", "r")

lines = f.readlines()

devices = []
handlers = []

for i in range(0, len(lines)):
    if (lines[i][0] == 'N'):
        if ("js" not in lines[i+4]): continue
        devices.append(lines[i][9:-2])
        handlers.append(lines[i+4][12:-1])

for i in range(0, len(devices)):
    print(devices[i])
    print(handlers[i])
