#!/bin/bash
speedtest-cli --no-$1 --simple | egrep -v -i "ping|$1" | awk '{print $2}' | sed 's/ //g'