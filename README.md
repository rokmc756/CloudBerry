## CloudBerry Database Arichtecture
![alt text](https://github.com/rokmc756/CloudBerry/blob/main/roles/cbdb/images/cbdb-architecture.png)

## What is CloudBerry?
Cloudberry Database, built on the latest PostgreSQL 14.4 kernel, is one of the most advanced and mature open-source MPP databases available.
It comes with multiple features, including high concurrency and high availability. It can perform quick and efficient computing for complex tasks,
meeting the demands of managing and computing vast amounts of data.

## Where is CloudBerry from and How is it changed?
GPFarmer has been developing based on cbdb-ansible project - https://github.com/andreasscherbaum/cbdb-ansible. Andreas! Thanks for sharing it.
Since it only provide install cbdb on a single host GPFarmer support multiple hosts and many extensions to deploy them and support two binary type, rpm and bin.

## Supported cbdb and extension version
* CBDB 1.6.x

## Supported Platform and OS
* Virtual Machines
* Baremetal
* RHEL / CentOS / Rocky Linux 5.x,6.x,7.x,8.x,9.x


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

## Download / configure / run CloudBerry
#### 1) Clone GPFarmer ansible playbook and go to that directory
```
$ git clone https://github.com/rokmc756/CloudBerry
$ cd CloudBerry
```

#### 2) Configure password for sudo user in VMs where cbdb would be deployed
```
$ vi Makefile
ANSIBLE_HOST_PASS="changeme"  # It should be changed with password of user in ansible host that gpfarmer would be run.
ANSIBLE_TARGET_PASS="changeme"  # # It should be changed with password of sudo user in managed nodes that cbdb would be installed.
```

#### 3) Configure inventory for hostname, ip address, username and user's password
```yaml
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[master]
rk9-node01 ansible_ssh_host=192.168.1.71

[standby]
rk9-node02 ansible_ssh_host=192.168.1.72

[segments]
rk9-node03 ansible_ssh_host=192.168.1.73
rk9-node04 ansible_ssh_host=192.168.1.74
rk9-node05 ansible_ssh_host=192.168.1.75
```

#### 4) Configure variables for CBDB
```yaml
$ vi group_vars/all.yml
ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"

cbdb:
  # pkg_name: "cloudberrydb" # for 1.5.x
  pkg_name: "cloudberry-db" # for 1.6.x
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
  domain: "jtest.pivotal.io"
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
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.7"
    ipaddr1: "192.168.1.7"
    ipaddr2: "192.168.2.7"
  client:
    net:
      type: "virtual"              # Or Physical
      cores: 1
      ipaddr0: "192.168.0.6"
      ipaddr1: "192.168.1.6"
      ipaddr2: "192.168.2.6"
  ext_storage:
    net:
      ipaddr0: "192.168.0."
      ipaddr1: "192.168.1."


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
```

#### 9) Configure order of roles in CloudBerry Anisble Playbook and Deploy CBDB and Extentions
```yaml
$ vi setup-common.yml
---
- hosts: all
  become: true
  roles:
   - { role: common }

$ make cbdb r=install s=common

$ vi setup-cbdb.yml
---
- hosts: all
  become: true
  roles:
   - { role: cbdb }


$ make cbdb r=prepare

$ make cbdb r=install s=db

$ make cbdb r=install s=standby

$ make cbdb r=install s=rg

$ make cbdb r=install s=tls

``

## Planning
Change CentOS and Rocky Linux repository into local mirror in Korea\
Converting Makefile.init from original project\
Adding SELinux role\
Adding tuned role\
