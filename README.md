## CloudBerry Database Arichtecture
![alt text](https://github.com/rokmc756/CloudBerry/blob/main/roles/cbdb/images/cbdb-architecture.png)
In most cases, Cloudberry Database is similar to PostgreSQL in terms of SQL support, features, configuration options, and user functionalities.
Users can interact with Cloudberry Database in a similar way to how they interact with a standalone PostgreSQL system.
Cloudberry Database uses MPP (Massively Parallel Processing) architecture to store and process large volumes of data, by distributing data and computing workloads across multiple servers or hosts.
MPP, known as the shared-nothing architecture, refers to systems with multiple hosts that work together to perform a task.
Each host has its own processor, memory, disk, network resources, and operating system.
Cloudberry Database uses this high-performance architecture to distribute data loads and can use all system resources in parallel to process queries.
From users' view, Cloudberry Database is a complete relational database management system (RDBMS).
In a physical view, it contains multiple PostgreSQL instances. To make these independent PostgreSQL instances work together, Cloudberry Database performs distributed cluster processing at different levels for data storage, computing, communication, and management.
Cloudberry Database hides the complex details of the distributed system, giving users a single logical database view. This greatly eases the work of developers and operational staff.

## What is CloudBerry?
Cloudberry Database, built on the latest PostgreSQL 14.4 kernel, is one of the most advanced and mature open-source MPP databases available.
It comes with multiple features, including high concurrency and high availability. It can perform quick and efficient computing for complex tasks,
meeting the demands of managing and computing vast amounts of data.

## Where is CloudBerry from and How is it changed?
GPFarmer has been developing based on cbdb-ansible project - https://github.com/andreasscherbaum/gpdb-ansible. Andreas! Thanks for sharing it.
Since it only provide install cbdb on a single host GPFarmer support multiple hosts and many extensions to deploy them and support two binary type, rpm and bin.

## Supported CBDB and Extension Version
* CBDB 1.6.x

## Supported Platform and OS
* Virtual Machines
* Baremetal
* RHEL / CentOS / Rocky Linux 9.x


## Prerequisite
MacOS or Fedora/CentOS/RHEL should have installed ansible as ansible host.
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt

## Prepare ansible host to run GPFarmer
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

* Fedora/CentOS/RHEL
```
$ sudo yum install ansible
```

## Prepareing OS
Configure Yum / Local & EPEL Repostiory

## Download / Configure / Run CloudBerry
#### 1) Clone CloudBerry Ansible Playbook and Go to the Directory
```
$ git clone https://github.com/rokmc756/CloudBerry
$ cd CloudBerry
```

#### 2) Configure Password for Uudo User in VMs Where CBDB would be Deployed
```
$ vi Makefile
ANSIBLE_HOST_PASS="changeme"  # It should be changed with password of user in ansible host that gpfarmer would be run.
ANSIBLE_TARGET_PASS="changeme"  # # It should be changed with password of sudo user in managed nodes that cbdb would be installed.
```

#### 3) Configure inventory for hostname, ip address, username and user's password
```yaml
$ vi ansible-hosts-rk9
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[master]
rk9-node01 ansible_ssh_host=192.168.2.191

[standby]
rk9-node02 ansible_ssh_host=192.168.2.192

[segments]
rk9-node03 ansible_ssh_host=192.168.2.193
rk9-node04 ansible_ssh_host=192.168.2.194
rk9-node05 ansible_ssh_host=192.168.2.195
```

#### 4) Prepare Linux Hosts installing Prerequistes Packages and Add Admin User in order to deploy CloudBerry Database
```yaml
$ make hosts r=init s=all
```

#### 5) Configure CBDB Global Variables
```yaml
$ vi group_vars/all.yml
ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"

cbdb:
  pkg_name: "cloudberry-db" # for 1.6.x ,  pkg_name: "cloudberrydb" # for 1.5.x
  cluster_name: jack-kr-cbdb
  base_dir: "/usr/local"
  admin_user: "gpadmin"
  admin_passwd: "changeme"
  admin_home_dir: "/home/gpadmin"
  coordinator_data_dir: "/data/coordinator/gpseg-1"
  data_dir: "/data"
  major_version: 1
  minor_version: 6
  patch_version: 0
  build_version: 1
  os_name: 'el9'
  # os_name: 'rl9'
  arch_name: 'x86_64'
  binary_type: 'rpm'
  number_segments: 4
  mirror_enable: true
  spread_mirrors: ""
  initdb_single: False
  initdb_with_standby: True
  seg_serialized_install: False
  domain: "jtest.futurfusion.io"
  repo_url: ""
  download_url: ""
  download: false
  base_path: /root
  host_num: "{{ groups['all'] | length }}"
  cgroup: v1
  metric_major_version: 6
  metric_minor_version: 26.0
  metric_build_version:
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.2.1"
    ipaddr0: "192.168.0.19"
    ipaddr2: "192.168.2.19"
  client:
    net:
      type: "virtual"              # Or Physical
      cores: 1
      ipaddr0: "192.168.0.19"
      ipaddr2: "192.168.2.19"
  ext_storage:
    net:
      ipaddr0: "192.168.0."
  vms:
    rk9: [ "rk9-freeipa", "rk9-node01", "rk9-node02", "rk9-node03", "rk9-node04", "rk9-node05" ]
    ubt24: [ "rk9-freeipa", "ubt24-node01", "ubt24-node02", "ubt24-node03", "ubt24-node04", "ubt24-node05" ]
  debug_opt: ""  # --debug


jdk:
  oss:
    install: true
    jvm_home: "/usr/lib/jvm"
    major_version: 1
    minor_version: 8
    patch_version: 0
    # 1.8.0
    # 11.0.4
    # 17.0.2
  oracle:
    install: false
    jvm_home: "/usr/lib/jvm"
    major_version: 13
    minor_version: 0
    patch_version: 2
    download: false


vmware:
  esxi_hostname: "192.168.0.231"
  esxi_username: "root"
  esxi_password: "Changeme34#$"


kvm:
  hostname: "192.168.0.101"
  username: "root"
  password: "changeme"
```

#### 6) Deploy CBDB and Extentions by Playbook
```yaml
$ make cbdb r=prepare

$ make cbdb r=install s=db

$ make cbdb r=add s=standby

$ make cbdb r=enable s=tls

$ make cbdb r=enable s=rg

or
$ make cbdb r=prepare
$ make cbdb r=install s=all
```


#### 7) Deploy or Destroy PXF Extentions
```yaml
$ make pxf r=install s=all
$ make pxf r=uninstall s=all
```


#### 8) Destroy CBDB and Extentions
```yaml
$ make cbdb r=disable s=rg
$ make cbdb r=uninstall s=db

or
$ make cbdb r=uninstall s=all
```


## Planning
- [O] Need to fix SEGFAULT when enabling SSL - https://knowledge.broadcom.com/external/article/382919/master-panics-after-enabling-ssl-on-gree.html
- [ ] Fixing Initialize Coodinator with Standby\
- [ ] Change CentOS and Rocky Linux repository into local mirror in Korea\
- [ ] Converting Makefile.init from original project\
- [ ] Adding SELinux role\
- [ ] Adding tuned role


