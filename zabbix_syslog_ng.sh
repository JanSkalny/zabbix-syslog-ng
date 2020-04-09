#!/bin/bash

fail() {
	echo "$*" 1>&2
	exit 1
}

usage() {
	fail "usage: $0 (discover|processed) [ITEM]"
	exit 1
}

syslog_stats() {
	RES=$( syslog-ng-ctl stats | sed 's/;/_/' | sed 's/;/_/'| grep "^$2;" | grep ";$1;[0-9]*$" | cut -d';' -f4 | head -n1 )
	[[ $RES =~ ^[0-9]+ ]] || fail "no such item $2"
	echo "$RES"
}

[ "$#" -lt 1 ] && usage

case "$1" in
discover)
	syslog-ng-ctl stats | grep -v '^destination;\(d_auth\|d_cron\|d_daemon\|d_kern\|d_lpr\|d_mail\|d_syslog\|d_user\|d_uucp\|d_mailinfo\|d_mailwarn\|d_mailerr\|d_newscrit\|d_newserr\|d_newsnotice\|d_debug\|d_error\|d_messages\|d_console\|d_console_all\|d_xconsole\|d_ppp\);' | grep ';processed;[0-9]*$' | cut -d';' -f1-3 | sed 's/;/_/g' | sort | uniq | jq -Rs '(. / "\n") - [""] | {data: [{ "{#SYSLOG_NG_QUEUE}": .[] }] }'
	;; 

processed | written | dropped | queued)
	syslog_stats "$1" "$2" || fail "syslog-ng-ctl stats failed!"
	;;

*)
	usage
	;;
esac

