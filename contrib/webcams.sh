#!/bin/sh

TARGET=$1

wget -q -O $TARGET/turm.jpg http://www.uni-luebeck.de/nc/webcam/current/current.jpg &
wget -q -O $TARGET/beckergrube.jpg http://212.108.160.103/axis-cgi/jpg/image.cgi &
wget -q -O $TARGET/altstadt.jpg http://thomasknauf.dyndns.org/record/current.jpg &
wget -q -O $TARGET/holstentor.jpg http://www.pets-in-pink.de/online/templatemedia/all_lang/resources/webcam_luebeck_holstentor.jpg &
wget -q -O $TARGET/yachthafen.jpg http://www.marina-baltica.de/web/livecam.jpg &
wget -q -O $TARGET/ostpreussenkai.jpg http://www.dzulko.de/tl_files/images_webcam_live/webcam_02/current.jpg &
wget -q -O $TARGET/ostseestrand.jpg http://www.dzulko.de/tl_files/images_webcam_live/webcam_01/current.jpg &
wget -q -O $TARGET/priwall-strand.jpg http://www.seelichter.de/webcam.jpg &
wget -q -O $TARGET/baustelle.jpg http://www.cbbm.uni-luebeck.de/fileadmin/cam/cbbm-webcam.jpg &
wget -q -O $TARGET/porto.jpg http://www.giglionews.com/isoladelgiglio_porto.jpg &
