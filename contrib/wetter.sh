#!/bin/bash

TMPDIR=$(mktemp -d)

pushd $TMPDIR

seq 0 15 $[15*9] | \
  while read offset
  do
    date -d"$(date -d"1970-01-01 00:00:00$(date +%:z) \
      + $(dc -e "$(date +%s) d 60 15 * % - p") seconds" \
      +"%Y-%m-%d %H:%M:%S %Z - $offset minutes")" \
      +"http://www.wetteronline.de/?pid=p_radar_map&ireq=true&src=radar/vermarktung/p_radar_map/wom/%Y/%m/%d/Intensity/SHS/grey_flat/%Y%m%d%H%M_SHS_Intensity.gif"
  done | \
    nl | \
    while read n url; do
      wget \
        --user-agent 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)' \
        -qO${n}.gif "$url"
    done

convert -delay 30 $(ls -r) out.gif

popd

convert ${TMPDIR}/out.gif $1

rm -r $TMPDIR
