#!/bin/bash

export SHELL='/bin/bash'
export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

HOST=$1
USER=$2
PASSWORD=$3
MODE=$5
SAMPLING=$4

BAND=()
#BAND2=()

for i in $(/usr/lib/zabbix/externalscripts/script.exp $HOST $USER $PASSWORD $SAMPLING | egrep -A1 "RX|TX" | sed -n '2p; 4p; 7p; 9p' | awk '{ print $1 }'); do
	BAND+=($i)
done

DOWN_BEFORE=$(echo "${BAND[0]}" | tr -d '\r' | tr -d '\n')
UP_BEFORE=$(echo "${BAND[1]}" | tr -d '\r' | tr -d '\n')
DOWN_AFTER=$(echo "${BAND[2]}" | tr -d '\r' | tr -d '\n')
UP_AFTER=$(echo "${BAND[3]}" | tr -d '\r' | tr -d '\n')

#echo "DOWN: $DOWN_BEFORE $DOWN_AFTER"
#echo "UP: $UP_BEFORE $UP_AFTER"

DOWNLOAD=$(echo "($DOWN_AFTER-$DOWN_BEFORE)*8/($SAMPLING)" | bc)
UPLOAD=$(echo "($UP_AFTER - $UP_BEFORE)*8/($SAMPLING)" | bc)

if [ $MODE -eq 0 ]; then
	echo "$DOWNLOAD"
else
	echo "$UPLOAD"
fi

#if [ $(echo "$DOWNLOAD < 1024" | bc) -eq 1 ]; then
#	echo "DOWNLOAD: $DOWNLOAD bps"
#elif [ $(echo "$DOWNLOAD > 1024*1024" | bc) -eq 1 ]; then
#	echo "DOWNLOAD: "$(echo "scale=2; $DOWNLOAD/(1024*1024)" | bc)" Mbps"
#else
#	echo "DOWNLOAD: "$(echo "scale=2; $DOWNLOAD/1024" | bc)" Kbps"
#fi

#if [ $(echo "$UPLOAD < 1024" | bc) -eq 1 ]; then
#	echo "UPLOAD: $UPLOAD bps"
#elif [ $(echo "$UPLOAD > 1024*1024" | bc) -eq 1 ]; then
#        echo "UPLOAD: "$(echo "scale=2; $UPLOAD/(1024*1024)" | bc)" Mbps"
#else
#        echo "UPLOAD: "$(echo "scale=2; $UPLOAD/1024" | bc)" Kbps"
#fi
