#!/bin/bash

fail() {
	echo "$*" 1>&2
	exit 1
}

usage() {
	fail "usage: $0 (discover|processed) [ITEM]"
	exit 1
}

[ "$#" -le 1 ] && usage

case "$1" in
discover)
	syslog-ng-ctl stats | grep ';processed;[0-9]*$' | cut -d';' -f1-3 | sort | uniq | jq -Rs '(. / "\n") - [""] | {data: [{ "{#SYSLOG_NG_QUEUE}": .[] }] }'
	;;

processed)
	RES=$( syslog-ng-ctl stats | grep "^$2;"| grep ';processed;[0-9]*$' | cut -d';' -f6 | head -n1 || fail "syslog-ng-ctl stats failed!" )
	[[ $RES =~ ^[0-9]+ ]] || fail "no such item"
	echo "$RES"
	;;

*)
	usage
	;;
esac

