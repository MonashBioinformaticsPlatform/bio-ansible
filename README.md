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

Assume you know how to start new [virtual machine (vm)](https://en.wikipedia.org/wiki/Virtual_machine) 
instance and how to install and operate [ansible](http://docs.ansible.com/ansible/intro.html).

- Bring up a VM (AWS, NeCTAR, OpenStack, etc)
- Set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
- Edit the `hosts` file to add the VM IP address, edit `group_vars/all` files to change `main_guy`
  and `sudo_guy` to the username used to log into the remote machine.

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
you might need `sudo`. Also note that Ansible tasks are typically are 
‘idempotent’, meaning if you run them again, they will generally only make the 
changes they must in order to bring the system to the desired state. This means 
it is safe to rerun the same playbook multiple times.

These playbooks target Ubuntu 16.04 and 18.04 - they may work with small
modifications on other Debian-flavoured distros. YMMV.


## Running bio-ansible

#### Setup and dependencies

1. [Install ansible](http://docs.ansible.com/ansible/intro_installation.html)
    ```bash
    mkdir ~/.virtualenvs
    virtualenv ~/.virtualenvs/ansible
    source ~/.virtualenvs/ansible/bin/activate
    pip3 install -U pip
 
    # bio-ansible currently requires Ansible 2.4.x
    pip3 install -U "ansible<2.5"
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

Install everything - `sudo` privilege is required (on the target host[s]):
```bash
ansible-playbook -i hosts all.yml
```

Just the tools as a non-privilege user (no `sudo` required, the user defined in the `main_guy` variable is used):
```bash
ansible-playbook -i hosts bio.yml
```

Just the dependencies - `sudo` privilege is required:

```bash
ansible-playbook -i hosts common.yml
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

To build using your current clone of `bio-ansible` (eg for testing):
```bash
docker build -t bioansible -f docker/Dockerfile-local .
```

Several of the slower steps (`r_core`, `r_extras`, `blast`) are executed as 
separate `RUN` commands so that these get cached as intermediate Docker layers.
This allows a single task to be tested quickly (by tag) by adding it at the 
end of the `Dockerfile-local`. If you want to run all steps from scratch, run
with the `--no-cache` option:

```bash
docker build --no-cache -t bioansible:latest -f docker/Dockerfile-local .
```

To test a specific tag(s) in the `bio.yml` playbook (eg hisat2 and muscle):
```bash
docker build --build-arg TASK_TAGS=hisat2,muscle -t bioansible -f docker/Dockerfile-bio-tags .
```

To build a production image by pulling the master branch:
```bash
docker build -t bioansible:latest -f docker/Dockerfile-repo .
```

We also have a Dockerfile for building a lighter-weight container than only
runs the RNAsik pipeline:

```bash
docker build -t rnasik:latest -f docker/Dockerfile-rnasik .
docker run -t rnasik:latest -help
```

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

