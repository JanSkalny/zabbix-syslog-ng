#!/bin/bash

fail() {
	echo "$*" 1>&2
	exit 1
}

if [ "$#" -ne 1 ]; then
    fail "Illegal number of parameters"
fi

STATS=$(syslog-ng-ctl stats | grep "$1"| grep processed | head -1)
NUMBER=${STATS##*;}

re='^[0-9]+$'
if ! [[ $NUMBER =~ $re ]] ; then
   fail "Cant get syslog-ng stats for $0"
fi

echo "$NUMBER"
