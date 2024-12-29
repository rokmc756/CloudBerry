#!/bin/bash

HOST_NAME=mdw4
DBNAME=testdb
ssh gpadmin@$HOST_NAME "source /usr/local/cloudberry-db/greenplum_path.sh;
export postgix_pkgname=$(/usr/local/cloudberry-db/bin/gppkg -q --all | grep postgis);
/usr/local/cloudberry-db/bin/gppkg -r $postgis_pkgname
/usr/local/cloudberry-db/bin/gppkg -q --all
"
