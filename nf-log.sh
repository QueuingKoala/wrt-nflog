#!/bin/sh

# Copyright Josh Cepek 2012
# Licensed under the GNU GPL version 3

getEntries() {
	local node=/proc/sys/net/netfilter/nf_conntrack_count
	[ -r $node ] || return -1
	 now="$(cat $node)"
	
	# Error checking
	[ $? -ne 0 ] && return 1
	[ -z "$now" ] && return 1
	
	return 0
}
wantExit() {
	rm "$pidfile"
	exit 0
}
sendLog() {
	logger -t "nf_count" -p local4.notice "max=$max min=$min (since $rst_time)"
}
zeroLog() {
	# next line updates $now
	getEntries || exit 1
	min=$now
	max=$now
	rst_time="$(date)"
	min_time="$rst_time"
	max_time="$rst_time"
}
dumpMsg() {
	cat <<EOM > "$dumpfile"
nf-log at $(date) [since $rst_time]

Min:	$min	at $min_time
Max:	$max	at $max_time

Cur:	$now
EOM
}

# init vars
dumpfile="${1:-/tmp/nf-log}"
idle=${2:-3}
pidfile=/var/run/nf-log.pid
echo "$$" > $pidfile
zeroLog

trap wantExit INT TERM
trap sendLog USR1
trap zeroLog USR2
trap dumpMsg HUP

while :
do
	sleep $idle
	getEntries || exit 2
	[ "$now" -eq "-1" ] && exit 1

	# updates
	if [ $now -gt $max ]; then
		max=$now
		max_time="$(date)"
	fi
	if [ $now -lt $min ]; then
		min=$now
		min_time="$(date)"
	fi
done
