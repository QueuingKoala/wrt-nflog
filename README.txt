nf-log README

Best viewed with word-wrap enabled.

PURPOSE

This code was designed to launch a listener to monitor the Linux Netfilter conntrack bucket usage and report to the system logger on-demand.

This code was designed for an OpenWRT platform, so you may need to make modifications, especially to the initscript, for use on other targets. The main nf-log.sh code should be friendly to most standard shells.

LICENSING

This code is made available under the GNU GPL version 3. See Licensing\gpl-3.0.txt for full licensing details.

USAGE

As paired with the initscript, install nf-log.sh to /usr/local/sbin/ and background launch it (nf-log.sh &) or start with the initscript. The nf-log process will silently monitor conntrack bucket usage.

Interact with the program via the following signals:

INT or TERM: Request to shutdown. This will remove the pidfile and exit within $idle seconds (3 by default.)

USR1: Send min/max stats to the system logger. Values are not reset.

USR2: Reset min/max/time values.

HUP: Export current stats to $dumpfile (/tmp/nf-log by default.) This update will occur within $idle seconds of the signal.