#!/bin/bash

HOST_NAME=mdw4
DBNAME=testdb
ssh gpadmin@$HOST_NAME "source /usr/local/cloudberry-db/greenplum_path.sh; dropdb $DBNAME;
/usr/local/cloudberry-db/madlib/bin/madpack uninstall -s madlib -p greenplum -c gpadmin@$HOST_NAME:5432/$DBNAME;
psql -c \"drop schema madlib cascade;\";
export madlib_pkgname=$(/usr/local/cloudberry-db/bin/gppkg -q --all | tail -1);
/usr/local/cloudberry-db/bin/gppkg -r $madlib_pkgname
/usr/local/cloudberry-db/bin/gppkg -q --all
rm -rf /usr/local/cloudberry-db/madlib
"
