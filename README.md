# Co-op-on-Linux

Script that allows Co-op on any game on linux
,Currently only supports 2 Players

# How to use it

install dependencies :

[Debain]
- $~ sudo apt install weston firejail zenity

[Fedora]
- $~ sudo dnf install weston firejail zenity

[Arch]
- $~ sudo pacman -Sy weston firejail zenity

make it executable :

- $~ chmod +x Co-Op-On-Linux.sh 

run it :

- $~ ./Co-Op-On-Linux.sh 

After running the script for the first time, you can use --quickrun to skip the setup GUI for the resolution and controllers of each instance.

However, You still need to run the script without --quickrun to reconfigure controllers.

Here's quick guide on how to use --quickrun :

- $~ ./Co-Op-On-linux.sh --quickrun resolution /path/to/the/game

Example :

- $~ ./Co-Op-On-linux.sh --quickrun 1280x720 /home/user/game/thegame

It Works very well with native Linux games ,
It Should work with some games running under Wine/Proton (I didn't test many games) ,

 you just need to make launch script for the game,
if you are using Lutris you need to extract launch script for the game :

- $ lutris -l (for listing games ids)
- $ lutris -b "type any file name".sh lutris:"type gameid here"

then run it

- $~ ./Co-Op-On-linux.sh --quickrun 1280x720 /home/user/game/"file name".sh

# Tested Games

DRM-free games should work as long as the game doesn't prevent you form run it more than one time
,for Steam games it depends on the DRM, Some games works Some don't.

Terraria (Native) 
- Status: Works ✅️
- Additional Notes: on Steam client, Terraria status stuck on 'running' after exiting the game from both instance.

Borderlands 1 (Wine/Proton)
- Status: Works With minor issues ☑️
- Additional Notes: if you choose resolution lower than 1080p you going to have issues with the UI scale.

Stardew valley (Native)
- Status: Already Have in-game Co-op ✳️
- Additional Notes: Making sure you already know that if you don't 🙂️
