# Bio-Ansible 

[![Build Status](https://travis-ci.org/MonashBioinformaticsPlatform/bio-ansible.svg?branch=master)](https://travis-ci.org/MonashBioinformaticsPlatform/bio-ansible)

> Do bioinformatics not sys-admining - run the playbook and get back to work !

## Content 

- [Bio-Ansible](#bio-ansible)
  - [Content](#content)
  - [Quick start](#quick-start)
  - [Introduction](#introduction)
  - [Running bio-ansible](#running-bio-ansible)
      - [Setup and dependencies](#setup-and-dependencies)
      - [Running the playbooks](#running-the-playbooks)
      - [Installing specific tools](#installing-specific-tools)
  - [Building a Docker image](#building-a-docker-image)
  - [Frequently asked questions](#frequently-asked-questions)
  - [Other](#other)
    - [Manually downloading tarballs](#manually-downloading-tarballs)
    - [Manual scripts](#manual-scripts)

## Quick start

We assume some familiarity with [Ansible](http://docs.ansible.com/ansible/intro.html).

- Bring up a VM (AWS, OpenStack / NeCTAR, etc)
- Add your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2) to `~/.ssh/authorized_keys` on the instance
- Edit the `hosts` file to add the target VM IP address, edit `group_vars/all` files to change:
  - `sudo_guy` to the username used to log into the remote machine
  - `main_guy` to a username that will be created for installing software (can be the same as `sudo_guy`)

```bash
ansible-playbook -i hosts all.yml
```

## Introduction

This _bio-ansible_ is multi-potent as it can set up from scratch the whole army 
of servers with bioinformatics (genomic) focus or just install handful of 
selected tools. A subset of the _bio-ansible_ playbooks can be run as a 
as a non-privileged user, in particular if you are just installing bio-tools in
your home directory on a shared system (eg HPC).

However you still might need to install some "common" dependencies and for that 
you might need `sudo`. Also note that Ansible tasks are intended to be 
‘idempotent’, meaning if you run them again, they will generally only make the 
changes they must in order to bring the system to the desired state. This means 
it is safe to rerun the same playbook multiple times.

These playbooks target Ubuntu 20.04 and 22.04 - they may work with small
modifications on newer Ubuntu releases and other Debian-flavoured distros. YMMV.


## Running bio-ansible

#### Setup and dependencies

1. [Install ansible](http://docs.ansible.com/ansible/intro_installation.html)
    ```bash
    mkdir ~/.virtualenvs
    virtualenv -p python3 ~/.virtualenvs/ansible
    source ~/.virtualenvs/ansible/bin/activate
    pip3 install -U pip
 
    # bio-ansible requires Ansible 8 (ansible-core 2.15.x), newer versions may work
    pip3 install -U "ansible==8"
    ```
2. Clone the git repo:

    ```bash
    git clone https://github.com/MonashBioinformaticsPlatform/bio-ansible.git
    ```
3. Edit `hosts` file to include the remote host IP addresses into the appropriate group.
   If running against remote host(s), setup your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2) and use `ssh-add` to add them to the local sss-agent.

4. Edit `group/all` file to include your username as `main_guy` variable (this is the username used to access the target host[s])

5. *Optional*: Download any tar archives for non-FOSS software into `tarballs/` (or the
   path set in the `tarballs_path` variable) - 
   see the section on [manually downloading tarballs](#manually-downloading-tarballs) below.

#### Running the playbooks

Install many bioinformatics tools as 'modules'. 
This is often possible as a non-privileged user without `sudo`. 
The user defined in the `main_guy` variable is used:

```bash
ansible-playbook -i hosts bio.yml
```

Install system-wide dependencies and packages - `sudo` privilege is required:

```bash
ansible-playbook -i hosts common.yml
```

Interacive web-based services - `sudo` privilege is required:

```bash
ansible-playbook -i hosts common.yml
```

**Or**, if you want to try installing everything above in one go (`sudo` privilege is required on the target host[s]):
```bash
ansible-playbook -i hosts all.yml
```

#### Installing specific tools

Alternatively you can install specific tools without running the whole playbook by using tags:

```bash
ansible-playbook -i hosts bio.yml --tags samtools,star,subread
```
You can see all available tags for a playbook with:
```bash
ansible-playbook bio.yml --list-tags
```

Protip: _You can always add `-v` or `-vvv` options for verbose mode to help 
diagnose failures_

## Building a Docker image

See [README.docker.md](README.docker.md)

## Frequently asked questions

- [Playbook breakdown](supplementary/playbook_breakdown.md)
- [Full list of available tags](supplementary/list_of_tags.md)
- [List of required dependencies](supplementary/dependencies.md)
- [List of python pip packages](supplementary/pip_packages.md)
- [List of supported talball packages](tarballs)
- [To Do list](supplementary/TODO.md)

## Other

### Manually downloading tarballs

Because of the licenses some installation files need to be manually downloaded 
into a 'tarballs' directory. By default this is `tarballs` in the playbook base 
path - this location can be set using the `tarballs_path` variable if required. 
The `playbook.yml` will skip installation of those packages if it doesn't find 
the archive files in that directory.

### Manual scripts

There are scripts to download various databases in `scripts/`. These have 
deliberately not been added to ansible.

