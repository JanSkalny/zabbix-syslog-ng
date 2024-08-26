#!/bin/bash

fail() {
	echo "$*" 1>&2
	exit 1
}

usage() {
	fail "usage: $0 (discover-src|discover-dst|processed|queued|dropped|writen) [ITEM]"
	exit 1
}

norm() {
    cut -d ';' -f 2-3 | sed 's/[#;,]/_/g' | sed 's/_$//'
}

zbx_discover() {
	sort | uniq | jq -Rs '(. / "\n") - [""] | {data: [{ "{#'$1'}": .[] }] }'
}

syslog_stats() {
	RES=""

	while IFS= read -r LINE; do
		if [[ "$(echo "$LINE" | norm)" == "$2" ]]; then
			RES=$( echo "$LINE" | cut -d ';' -f6 | head -n 1)
			break
		fi
	done < <(syslog-ng-ctl stats | grep ";$1;[0-9]\+$")

	[[ $RES =~ ^[0-9]+ ]] || fail "no such item $2"
	echo "$RES"
}


[ "$#" -lt 1 ] && usage

case "$1" in
discover-src)
	syslog-ng-ctl stats | grep '^source;' | norm | zbx_discover "SYSLOG_NG_SRC"
	;;

discover-dst)
	syslog-ng-ctl stats | grep '^dst\.[^;]*;' | norm | zbx_discover "SYSLOG_NG_DST"
	;;

processed | written | dropped | queued)
	syslog_stats "$1" "$2" || fail "syslog-ng-ctl stats failed!"
	;;

*)
	usage
	;;
esac
