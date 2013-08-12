OpenWRT nf-log README
=====================

Best viewed with word-wrap enabled.

Purpose
-------

This code was designed to launch a listener to monitor the Linux Netfilter conntrack bucket usage and report to the system logger on-demand.

This code was designed for an OpenWRT platform, so you may need to make modifications, especially to the initscript, for use on other targets. The main nf-log.sh code should be friendly to most standard shells.

Licensing
---------

This code is made available under the GNU GPL version 3. See Licensing\gpl-3.0.txt for full licensing details.

Using the nflog initscript
--------------------------

The nflog.init.sh script should be installed on the OpenWRT system to /etc/init.d/nflog. Once there, it expects to find nf-log.sh at /usr/local/sbin/ as well. Both programs must be marked executable to be run.

If desired, the script may be enabled for start on boot with the traditional `/etc/init.d/nflog enable` command. Once started, nf-log.sh will silently run in the background collecting the min/max Netfilter conntrack state usage.

In order to report the stats to the system log, call the initscript with the command `/etc/init.d/nflog lognow` which will report the min/max count to the system logger and reset the counters. The log entry will also contain the date/time of the last stat zeroing. If desired, one may also `zero` the counters without any logging.

As an additional feature, the command `/etc/init.d/nflog show` will dump stats to a file (/tmp/nf-log) and display its contents to the terminal. This is designed for manual reporting of the min/max counters and will not zero out the counters.

Regular reporting
-----------------

The intent of nflog is to be called on a regular basis with the `lognow` command, such as out of cron. For instance, the following cron entry could be used to report the min/max state usage hourly:

`00 * * * * /etc/init.d/nflog lognow`

This interval can be adjusted to suite the local reporting needs. It may also be a benefit to set up a remote syslog server and configure OpenWRT to perform network logging; this is especially helpful if state usage ends up causing the router to lock up or reboot as the RAM-based logs are lost in such cases.

Manual nf-log.sh usage
----------------------

Normally nf-log is designed to be controlled through the initscript by calling /etc/init.d/nflog as described above. The following describes the operation of nf-log.sh directly.

Once started, the nf-log process will silently monitor conntrack bucket usage. It will not report or reset stats unless explicitly requested.

Interact with the program via the following signals:

* INT or TERM: Request to shutdown. This will remove the pidfile and exit within $idle seconds (3 by default.)

* USR1: Send min/max stats to the system logger. Values are not reset.

* USR2: Reset min/max/time values.

* HUP: Export current stats to $dumpfile (/tmp/nf-log by default.) This update will occur within $idle seconds of the signal.
