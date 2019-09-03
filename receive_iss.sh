#!/bin/sh
datetime=$(date +"%Y%m%d-%H%M%S")
timeout 660 /usr/bin/rtl_fm -M fm -f 145.8M -s 48k -g 50 -p 55 -E wav -E deemp -F 9 - | /usr/bin/sox -t raw -e signed -c 1 -b 16 -r 48000 - /usr/share/html/audio/iss-$datetime.wav rate 11025
