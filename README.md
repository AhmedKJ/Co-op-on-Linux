# Co-op-on-Linux
Proof of concept Script that allows Co-op on any game on linux
# How to use it

 install dependencies

[Debain]
- $ sudo apt install weston firejail

[Fedora]
- $ sudo dnf install weston firejail

make it executable

- $ chmod +x Co-Op-On-Linux.sh 

run it

- $ ./Co-Op-On-Linux.sh 

NOTE: It Works very well with native Linux games ,
It Should work with lutris games (i didn't test many games) , you just need to extract launch script for the game 

- $ lutris -b lutris:(gameid) (file name)
