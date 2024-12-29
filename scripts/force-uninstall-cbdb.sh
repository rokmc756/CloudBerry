#!/bin/bash
#
# HOSTS_RANGE="51 55"
# HOSTS_RANGE="61 65"    # co7
# HOSTS_RANGE="171 175"
# HOSTS_RANGE="81 85"    # rk8
# HOSTS_RANGE="141 145"  # rh8



HOSTS_RANGE="71 75"      # rh7

NETWORK_RANGE="192.168.0"
USER="root"

for i in `seq $HOSTS_RANGE`
do
    ssh $USER@$NETWORK_RANGE.$i "
        killall postgres python > /dev/null 2>&1;
        rpm -e cloudberrydb --allmatches > /dev/null 2>&1;
        rpm -e cloudberry-db --allmatches > /dev/null 2>&1;
        rpm -e --allmatches cloudberrydb > /dev/null 2>&1;
        rpm -e --allmatches cloudberry-db > /dev/null 2>&1;
        rpm -e --allmatches  open-source-cloudberry-db-6-6.26.1-1.el7.x86_64 > /dev/null 2>&1;
        rpm -e --allmatches greenplum-disaster-recovery > /dev/null 2>&1;
        dpkg -r cloudberry-db-6 > /dev/null 2>&1;
        rm -rf /home/gpadmin/greenplum*.zip /home/gpadmin/greenplum*.rpm /data/master /data/primary /data/mirror /home/gpadmin/gpinitsystem_config \
        /usr/local/cloudberrydb* /usr/local/cloudberry-db* /tmp/.s.PGSQL.* /data/coordinator \
        /data/master/gpsne-1 /data/primary/gpsne{0..9} /data/mirror/gpsne{0..9} /data/coodinator /data/master /data/master/gpsne-1 /data/primary/gpsne{0..9} /data/mirror/gpsne{0..9};
        killall postgres python > /dev/null 2>&1;
        rm -f /etc/cgconfig.d/cbdb.conf;
        echo "" > /etc/sysctl.conf;
        rm -f /etc/sysctl.d/99-sysctl.conf
        systemctl stop cgconfig;
        systemctl disable cgconfig;
        rm -f /etc/cgconfig.conf;
        "
done

#       rm -rf /home/gpadmin/.ssh;
#       rm -rf /home/gpadmin/*;
#       rm -rf /home/gpadmin;
#       userdel gpadmin

