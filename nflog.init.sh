#!/bin/sh /etc/rc.common

# Copyright Josh Cepek 2012
# Licensed under the GNU GPL version 3

# initscript designed for use under OpenWRT.
# Alter to your site requirements or port as needed

NAME=nf_log
START=99
STOP=05
EXTRA_COMMANDS="show lognow zero"
EXTRA_HELP="	show Shows current bucket usage
	lognow Sends & resets current stats to log
	zero Resets current stats WITHOUT logging"
PIDFILE=/var/run/nf-log.pid
MSGFILE=/tmp/nf-log
PROG=/usr/local/sbin/nf-log.sh

checkstatus() {
	[ -r $PIDFILE ] && kill -0 $(cat $PIDFILE) && return 0
	[ -r $PIDFILE ] && rm $PIDFILE
	return 1
}
start() {
	checkstatus || $PROG &
}
stop() {
	lognow
	checkstatus && kill -TERM $(cat $PIDFILE)
}
show() {
	checkstatus || {
		echo "$NAME: not running"
		exit
	}
	kill -HUP $(cat $PIDFILE)
	sleep 4 # this should match $idle +1 from nf-log.sh
	cat $MSGFILE
}
lognow() {
	checkstatus || {
		echo "$NAME: not running"
		exit
	}
	kill -USR1 $(cat $PIDFILE)
	kill -USR2 $(cat $PIDFILE)
}
zero() {
	checkstatus || {
		echo "$NAME: not running"
		exit
	}
	kill -USR2 $(cat $PIDFILE)
}
