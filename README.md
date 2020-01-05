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

`managed_services: <list-of-services (prometheus | alertmanager)>` (**default**: *['prometheus', 'alertmanager']*)
- list of Prometheus toolkit services to manage via this role

`prometheus_user: <service-user-name>` (**default**: *prometheus*)
- dedicated service user and group used by `prometheus` for privilege separation (see [here](https://www.beyondtrust.com/blog/entry/how-separation-privilege-improves-security) for details)

`install_dir: </path/to/installation/dir>` (**default**: `/opt/prometheus`)
- path on target host where the `prometheus` binaries should be extracted to

`archive_url: <path-or-url-to-archive>` (**default**: see `defaults/main.yml`)
- address of a compressed **tar or zip** archive containing `prometheus` binaries. This method technically supports installation of any available version of `prometheus`. Links to official versions can be found [here](https://prometheus.io/download/#prometheus).

`archive_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified `prometheus` archive. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value.

`checksum_format: <string>` (**default**: see `sha256`)
- hash algorithm used for file verification associated with the specified archive checksum. Reference [here](https://en.wikipedia.org/wiki/Cryptographic_hash_function) for more information about *checksums/cryptographic* hashes.

`alertmgr_installdir: </path/to/installation/dir>` (**default**: `/opt/alertmanager`)
- path on target host where the `alertmanager` binaries should be extracted to

`alertmgr_archive_url: <path-or-url-to-archive>` (**default**: see `defaults/main.yml`)
- address of a compressed **tar or zip** archive containing `alertmanager` binaries. This method technically supports installation of any available version of `alertmanager`. Links to official versions can be found [here](https://prometheus.io/download/#alertmanager).

`alertmgr_archive_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified `alertmanager` archive. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value.

`alertmgr_checksum_format: <string>` (**default**: see `sha256`)
- hash algorithm used for file verification associated with the specified archive checksum. Reference [here](https://en.wikipedia.org/wiki/Cryptographic_hash_function) for more information about *checksums/cryptographic* hashes.

#### Config

Using this role, configuration of a `prometheus` installation is organized according to the following components:

* prometheus service configuration (`prometheus.yml`)
* file service discovery (`file_sd - *.[json|yml]`)
* recording and alerting rules (`rule_files - *.rules`)
* alertmanager service configuration (`alertmanager.yml`)
* alertmanager template files (`*.tmpl`)

Each configuration can be expressed within the following variables in order to customize the contents and settings of the designated configuration files to be rendered:

#### Prometheus Service configuration

Prometheus service configuration can be expressed within the hash, `prometheus_config`, which contains a set of key-value pairs representing one of a set of sections indicating various scrape targets (sources from which to collect metrics), service discovery mechanisms, recording/alert rulesets and configurations for interfacing with remote read/write systems utlized by the Prometheus service.

The values of these keys are generally dicts or lists of dicts themselves containing a set of key-value pairs representing associated specifications/settings (e.g. the scrape interval or frequency at which to scrape targets for metrics globally) for each section. The following provides an overview and example configurations of each for reference.

##### :global

`[prometheus_config:] global: <key: value,...>` (**default**: see `defaults/main.yml`)
- specifies parameters that are valid and serve as defaults in all other configuration contexts. See  [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) for more details.

##### Example

 ```yaml
  prometheus_config:
    global:
      # How frequently to scrape targets by default.
      scrape_interval: 15s
      # How long until a scrape request times out.
      scrape_timeout: 30s
      # How frequently to evaluate rules.
      evaluation_interval: 30s
      # The labels to add to any time series or alerts when communicating with
      # external systems (federation, remote storage, Alertmanager).
      external_labels:
        monitor: example
        foo: bar
  ```
  
  ##### :scrape_configs

`[prometheus_config:] scrape_configs: <list-of-dicts>` (**default**: see `defaults/main.yml`)
- specifies a set of targets and parameters describing how to scrape them. Targets may be statically configured or dynamically discovered using one of the supported service discovery mechanisms. See [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) for more details and [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) for a list of supported service discovery methods.

##### Example

 ```yaml
  prometheus_config:
    scrape_configs:
      - job_name: static-example
        static_configs:
        - targets: ['localhost:9090', 'localhost:9191']
          labels:
            example: label
      - job_name: kubernetes-example
        kubernetes_sd_configs:
        - role: endpoints
          api_server: 'https://localhost:1234'
          namespaces:
            names:
              - default
  ```
  ##### :rule_files

`[prometheus_config:] rule_files: <list>` (**default**: see `defaults/main.yml`)
- specifies a list of globs indicating file names and paths. Rules and alerts are read from all matching files. Rules fall into one of two categories: recording and alerting. See [here](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) for details surrounding recording rules and [here](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) for details surrounding alerting rules.

##### Example

 ```yaml
  prometheus_config:
    rule_files:
    - "example.rules"
    - "example/*.rules"
  ```
  
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
