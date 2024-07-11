#!/usr/bin/env python

import sys
from pathlib import Path

if len(sys.argv) < 2 or sys.argv[1] == "help":
    print("""get-devices.py usage

help: Display this help
list-handlers: list all gamepad handlers
list-names: list all gamepad names
list-zenity: list all gamepad handlers and names on a format for zenity (Each line it displays name and the next, handler)
list-zenity-exclude <handlers...>: like list-zenity but excludes the devices with the specified handlers
list-handlers-exclude <handlers...>: list all gamepad handlers excluding the ones specified on the command arguments
    """)
    exit()

f = open("/proc/bus/input/devices", "r")

lines = f.readlines()

devices = []
handlers = []

for i in range(0, len(lines)):
    if (lines[i][0] == 'N'):
        if ("js" not in lines[i+4]): continue
        devices.append(lines[i][9:-2])
        devhandlers = []

        syspath = "/sys" + lines[i+2][9:]
        p = Path(syspath)
        p = p.parent.parent / "hidraw"
        if (p.exists()):
            for a in p.iterdir():
                devhandlers.append("/dev/"+a.name)

        for h in lines[i+4][12:-2].split(" "):
            devhandlers.append("/dev/input/"+h)

        handlers.append(" ".join(devhandlers))

if sys.argv[1] == "list-handlers-exclude":
    for a in range(2, len(sys.argv)):
        for i in range(0, len(handlers)):
            if (i > len(handlers)-1): break
            if sys.argv[a] in handlers[i]:
                del handlers[i]


    for i in range(0, len(handlers)):
        print(handlers[i], end=" ")
    print("\n", end="")

if sys.argv[1] == "list-handlers":
    for i in range(0, len(handlers)):
        print(handlers[i])

if sys.argv[1] == "list-names":
    for i in range(0, len(devices)):
        print(devices[i])

if sys.argv[1] == "list-zenity" or sys.argv[1] == "list-zenity-exclude":
    if sys.argv[1] == "list-zenity-exclude":
        for a in range(2, len(sys.argv)):
            for i in range(0, len(handlers)):
                if (i > len(handlers)-1): break
                if sys.argv[a] in handlers[i]:
                    del handlers[i]
                    del devices[i]

    for i in range(0, len(devices)):
        print(devices[i])
        print(handlers[i])
