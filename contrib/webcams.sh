#!/bin/sh

TARGET=$1
MAXAGE=100

fetch() {
  URL=$1
  FN=$2
  DATE=$(date +%F-%H-%M-%S)
  FILE=$FN-$DATE.jpg

  cd $TARGET

  wget --timeout=15 -q -O $FILE $URL

  # check jpeg and delete file in case of errors
  jpeginfo -qc $FILE || rm -v $FILE

  find . -name $FN-\* -mmin +$MAXAGE -delete
}

fetch http://www.uni-luebeck.de/nc/webcam/current/current.jpg turm &
fetch http://212.108.160.103/axis-cgi/jpg/image.cgi beckergrube &
fetch http://thomasknauf.dyndns.org/record/current.jpg altstadt &
fetch http://www.pets-in-pink.de/online/templatemedia/all_lang/resources/webcam_luebeck_holstentor.jpg holstentor &
fetch http://www.marina-baltica.de/web/livecam.jpg yachthafen &
fetch http://www.dzulko.de/tl_files/images_webcam_live/webcam_02/current.jpg ostpreussenkai &
fetch http://www.dzulko.de/tl_files/images_webcam_live/webcam_01/current.jpg ostseestrand &
fetch http://www.seelichter.de/webcam.jpg priwall-strand &
fetch http://www.cbbm.uni-luebeck.de/fileadmin/cam/cbbm-webcam.jpg baustelle &
fetch http://www.giglionews.com/isoladelgiglio_porto.jpg porto &
fetch http://gast:gast@10.130.0.68/snapshot.cgi fluse100 &
fetch http://www.wetterstation-luebeck.de/Wolken/camwolke.jpg camwolke &
