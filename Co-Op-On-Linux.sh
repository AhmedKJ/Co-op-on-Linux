#!/bin/bash
### Manage game controllers 
CONTROLLER_LIST=$(ls -l /dev/input/by-id/ | grep joystick |  awk '{gsub("-joystick", ""); gsub("-event", ""); print $9}' | uniq)
PS3="Choose controller for player 1 : "
select filename in ${CONTROLLER_LIST}; do CONTROLLER_1=${filename}; break; done
PS3="Choose controller for player 2 : "
select filename in ${CONTROLLER_LIST}; do CONTROLLER_2=${filename}; break; done
js_CONTROLLER_1=$( ls -l /dev/input/by-id/ | grep $CONTROLLER_1 | grep js | awk  '{ gsub("../", ""); print $11 }' )
js_CONTROLLER_2=$( ls -l /dev/input/by-id/ | grep $CONTROLLER_2 | grep js | awk  '{ gsub("../", ""); print $11 }' )
### Getting game path/command
echo "( Don't use ~ or HOME for the path )"
read -e -p "Enter game executable path/launch command : " GAMERUN

### Writing Config files for Weston
DIR_CO_OP="$HOME/Co-Op_On_Linux"
if [ -d $DIR_CO_OP ]; then
echo "Directory exists."
else
mkdir $DIR_CO_OP
printf "[core]
xwayland=true
idle-time=0
[shell]
locking=false

[keyboard]
keymap_layout=gb

[launcher]
icon=/usr/share/weston/icon_terminal.png
path=/usr/bin/weston-terminal

[launcher]
icon=/usr/share/icons/hicolor/24x24/apps/firefox.png
path=/usr/bin/firefox" >> $DIR_CO_OP/weston0.ini

cp $DIR_CO_OP/weston0.ini $DIR_CO_OP/weston1.ini
cp $DIR_CO_OP/weston0.ini $DIR_CO_OP/weston2.ini
fi
### Setup resolution for Weston sessions
printf " Enter Resolution for Weston sessions ( for example: 1280x720 ) : "
read Resolution
WIDTH=$(printf $Resolution | awk -F "x" '{print $1}')
HEIGHT=$(printf $Resolution | awk -F "x" '{print $2}')

### Launching Weston sessions
weston --xwayland -c "$DIR_CO_OP/weston0.ini" --width=1024 --height=768 2> /dev/null &
sleep 2
weston --xwayland -c "$DIR_CO_OP/weston1.ini" --width=$WIDTH --height=$HEIGHT 2> /dev/null &
sleep 2
weston --xwayland -c "$DIR_CO_OP/weston2.ini" --width=$WIDTH --height=$HEIGHT 2> /dev/null &
sleep 2
notneeded=$(ps l | grep weston0.ini | awk 'length($0) > 120 {print $3}')
kill $notneeded
sleep 1

### Launching instances
#---Player 1---#
DISPLAY=:2 WAYLAND_DISPLAY=wayland-1 firejail --noprofile --blacklist="/dev/input/by-id/$CONTROLLER_2-joystick" --blacklist="/dev/input/by-id/$CONTROLLER_2-event-joystick" --blacklist="/dev/input/$js_CONTROLLER_2" "$GAMERUN" &
sleep 1
#---Player 2---#
DISPLAY=:3 WAYLAND_DISPLAY=wayland-2 firejail --noprofile --blacklist="/dev/input/by-id/$CONTROLLER_1-joystick" --blacklist="/dev/input/by-id/$CONTROLLER_1-event-joystick" --blacklist="/dev/input/$js_CONTROLLER_1" "$GAMERUN" &
sleep 1

echo "Done~!"
