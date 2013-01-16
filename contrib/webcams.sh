#!/bin/sh

TARGET=$1

wget -q -O $TARGET/turm.jpg http://www.uni-luebeck.de/nc/webcam/current/current.jpg &
wget -q -O $TARGET/beckergrube.jpg http://212.108.160.103/axis-cgi/jpg/image.cgi &
