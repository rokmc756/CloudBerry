- pgbouncer_info.py : print funcution added () due to error
- collectd-5.12.x and collectd-5.11.0-2 could not be build due to gcc error in Rokcy 8
- pmu-tools include jevent-devel package to need install collectd-5.11
- manual excution of pgbouncer got error
- source rpm can be downloaded at https://cbs.centos.org/koji/buildinfo?buildID=30740
- dependency rpm pakcages could be installed for building collectd package with command, yum -y install $(for i in `rpmbuild -ba collectd.spec 2>&1 | tail -9 | awk '{print $1}'`; do echo $i; done)
- pip2 install collectd need to run pgbouncer_info.py