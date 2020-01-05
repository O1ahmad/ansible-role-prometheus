<p><img src="https://cdn.worldvectorlogo.com/logos/prometheus.svg" alt="prometheus logo" title="prometheus" align="right" height="60" /></p>

Ansible Role :fire: :straight_ruler: Prometheus
=========
[![Galaxy Role](https://img.shields.io/ansible/role/45498.svg)](https://galaxy.ansible.com/0x0I/prometheus)
[![Downloads](https://img.shields.io/ansible/role/d/45498.svg)](https://galaxy.ansible.com/0x0I/prometheus)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-prometheus.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-prometheus)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Role Variables](#role-variables)
      - [Install](#install)
      - [Config](#config)
      - [Launch](#launch)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

Ansible role that installs and configures Prometheus: a multi-dimensional, non-distributed/stand-alone time-series database monitoring/alerting toolkit.

##### Supported Platforms:
```
* Debian
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

Requires the `unzip/gtar` utility to be installed on the target host. See ansible `unarchive` module [notes](https://docs.ansible.com/ansible/latest/modules/unarchive_module.html#notes) for details.

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_

#### Install

`prometheus`can be installed using compressed archives (`.tar`, `.zip`), downloaded and extracted from various sources.

_The following variables can be customized to control various aspects of this installation process, ranging from software version and source location of binaries to the installation directory where they are stored:_

`managed_services: <list-of-services (prometheus | alertmanager)>` (**default**: ['prometheus', 'alertmanager'])
- list of Prometheus toolkit services to manage via this role

`prometheus_user: <service-user-name>` (**default**: *prometheus*)
- dedicated service user and group used by `prometheus` for privilege separation (see [here](https://www.beyondtrust.com/blog/entry/how-separation-privilege-improves-security) for details)

`install_dir: </path/to/installation/dir>` (**default**: `/opt/prometheus`)
- path on target host where the `prometheus` binaries should be extracted to

`archive_url: <path-or-url-to-archive>` (**default**: see `defaults/main.yml`)
- address of a compressed **tar or zip** archive containing `prometheus` binaries. This method technically supports installation of any available version of `prometheus`. Links to official versions can be found [here](https://prometheus.io/download/#prometheus)

`archive_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified archive. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value

`checksum_format: <string>` (**default**: see `sha256`)
- hash algorithm used for file verification associated with the specified archive checksum. Reference [here](https://en.wikipedia.org/wiki/Cryptographic_hash_function) for more information about *checksums/cryptographic* hashes

`alertmgr_installdir: </path/to/installation/dir>` (**default**: `/opt/alertmanager`)
- path on target host where the `alertmanager` binaries should be extracted to

`alertmgr_archive_url: <path-or-url-to-archive>` (**default**: see `defaults/main.yml`)
- address of a compressed **tar or zip** archive containing `alertmanager` binaries. This method technically supports installation of any available version of `alertmanager`. Links to official versions can be found [here](https://prometheus.io/download/#alertmanager)

`alertmgr_archive_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified archive. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value

`alertmgr_checksum_format: <string>` (**default**: see `sha512`)
- hash algorithm used for file verification associated with the specified archive checksum. Reference [here](https://en.wikipedia.org/wiki/Cryptographic_hash_function) for more information about *checksums/cryptographic* hashes

#### Config

...*description of configuration related vars*...

#### Launch

...*description of service launch related vars*...

Dependencies
------------

- 0x0i.systemd

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.prometheus
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
