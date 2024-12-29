#!/bin/bash
#

cbdb_PID_FILE='/data/master/gpseg-1/postmaster.pid'
cbdb_PORT='5432'
cbdb_USER='gpadmin'
cbdb_HOST='192.168.0.172'
cbdb_LOCALIP="${1:-127.0.0.1}"
cbdb_REMOTEIP="${2:-127.0.0.1}"
LOG='/var/log/check-cbdb-vrrp.log'

. /etc/keepalived/functions-common.sh || exit 1
. /etc/keepalived/functions-cbdb.sh || exit 1

# Local cbdb checks
check_pid_file "${cbdb_PID_FILE}" || exit_err 'pid_file' 1
check_listen_port "${cbdb_PORT}" || exit_err 'listen_port' 1
check_cbdb_connect "${cbdb_LOCALIP}" || exit_err 'cbdb_connect: Connect failure' 1
exit 0
