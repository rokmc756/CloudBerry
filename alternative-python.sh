# Need Test

alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
alternatives --config python3

# alternatives --set python /usr/bin/python3

# source /usr/local/cloudberry-db/greenplum_path.sh
# gpstop -ra
# Error: unable to import module: No module named '_pg'

# dnf install python3.12-psycopg2

dnf install python3.11

dnf install python3.11-devel

dnf install python3.11-psycopg2

pip install wheel

pip install setuptools

# X pip install PyGreSQL


dnf install kernel-devel
dnf install kernel-headers

# pip install PyGreSQL
# pip install psutils

# 
git clone PyGreSQL
git checkout 5.2.5
python setup.py install

pip install psutil==5.x.x

https://pypi.org/project/psutil/#history

