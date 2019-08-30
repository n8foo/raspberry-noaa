#!/bin/sh

## debug
set -x

. ~/.noaa.conf

wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O "${NOAA_DATA}"/predict/weather.txt
wget -qr http://www.celestrak.com/NORAD/elements/amateur.txt -O "${NOAA_DATA}"/predict/amateur.txt
grep "NOAA 15" "${NOAA_DATA}"/predict/weather.txt -A 2 > "${NOAA_DATA}"/predict/weather.tle
grep "NOAA 18" "${NOAA_DATA}"/predict/weather.txt -A 2 >> "${NOAA_DATA}"/predict/weather.tle
grep "NOAA 19" "${NOAA_DATA}"/predict/weather.txt -A 2 >> "${NOAA_DATA}"/predict/weather.tle
grep "ZARYA" "${NOAA_DATA}"/predict/amateur.txt -A 2 > "${NOAA_DATA}"/predict/amateur.tle

#Remove all AT jobs
for i in $(atq | awk '{print $1}');do atrm "$i";done

#Schedule Satellite Passes:
"${NOAA_RUN}"/schedule_sat.sh "NOAA 19" 137.1000
"${NOAA_RUN}"/schedule_sat.sh "NOAA 18" 137.9125
"${NOAA_RUN}"/schedule_sat.sh "NOAA 15" 137.6200
"${NOAA_RUN}"/schedule_iss.sh "ISS (ZARYA)" 145.8000
