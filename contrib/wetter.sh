#!/bin/bash

OUT=$1

URL=`wget -q --user-agent foo http://www.wetteronline.de/include/radar_dldl_00_dschf.htm -O-|grep Loop\ 90|sed 's%.*stdT\([[:digit:]]\{4\}\)\([[:digit:]]\{2\}\)\([[:digit:]]\{2\}\)\([[:digit:]]\{2\}\)\([[:digit:]]\{2\}\).*%http://www.wetteronline.de/daten/radar/dsch/\1/\2/\3/std_\4\5.gif%'`

FILE=/tmp/wetterkarte.gif

wget --user-agent foo -q -O$FILE $URL 
convert -delete 0-5 $FILE $FILE ${FILE}.out.gif

convert ${FILE}.out.gif $OUT

rm $FILE ${FILE}.out.gif

