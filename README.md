# Co-op-on-Linux
Scripts for that allows Co-op on any game on linux
# How to use it

- install dependencies

[Debain]
$ apt install weston firejail

[Fedora]
$ dnf install weston firejail

- make it executable

$ chmod +x Co-Op-On-Linux.sh 

- run it

./Co-Op-On-Linux.sh 

NOTE: It Works very well with native Linux games that doesn't require Steam to launch ,
It Should work with lutris games (i didn't test many games) , you just need to extract launch script for the game 
$ lutris -b lutris:(gameid) (file name)
