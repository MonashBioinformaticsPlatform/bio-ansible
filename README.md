# Bio-Ansible 

> Do bioinformatics not sys-admining - run the playbook and get back to work !

## Content 

- [Quick start](#quick-start)
- [Introduction](#introduction)
- [Running bio-ansible](#running-bio-ansible)
- [Building a Docker image](#docker)
- [Frequently asked questions](#frequently-asked-questions)
- [Other](#other)

## Quick start

Assume you know how to start new [virtual machine (vm)](https://en.wikipedia.org/wiki/Virtual_machine) instance and how to install and operate [ansible](http://docs.ansible.com/ansible/intro.html).

- bring up a vm (AWS, NeCTAR, OpenStack, etc)
- set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
- edit `host` file to add vm ip address, edit `groups_vars/all` files to change vm username

```BASH
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

These playbooks target Ubuntu 14.04 and 16.04 - they may work with small
modifications on other Debian-flavoured distros. YMMV.


## Running bio-ansible

#### Setup and dependencies

1. [Install ansible](http://docs.ansible.com/ansible/intro_installation.html)

```bash
mkdir ~/.virtualenvs
virtualenv ~/.virtualenvs/ansible
source ~/.virtualenvs/ansible/bin/activate
pip install -U pip
pip install ansible
```

2. `git clone https://github.com/MonashBioinformaticsPlatform/bio-ansible.git`

If running against remote host(s):

2b. Set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
2c. Edit `hosts` file to include the remote host IP addresses into the appropriate group
3. Edit `group/all` file to include your username as `main_guy` variable
4. Download any tar archives for non-FOSS software into `tarballs/` (or the
   path set in the `tarballs_path` variable) - 
see the section on [manually downloading tarballs](#manually-downloading-tarballs) below.

#### Running the playbooks

Install everything - `sudo` privilege is required:
```
ansible-playbook -i hosts all.yml
```

Just the tools as a non-privilege user (no `sudo` required):
```
ansible-playbook -i hosts bio.yml
```

Just the dependencies - `sudo` privilege is required:

```
ansible-playbook -i hosts common.yml
```

#### Installing specific tools

Alternatively you can install specific tools without running the whole playbook:

```BASH
ansible-playbook -i hosts bio.yml --tags samtools
ansible-playbook -i hosts bio.yml --tags star
ansible-playbook -i hosts bio.yml --tags subread
```

OR

```BASH
ansible-playbook -i hosts bio.yml --tags samtools,star,subread
```

Protip: _You can always add `-v` or `-vvv` options for verbose mode to help 
diagnose failures_

## Building a Docker image

To build using your current clone of `bio-ansible` (eg for testing):
```
docker build -t bioansible -f docker/Dockerfile-local .
```

Several of the slower steps (`r_core`, `r_extras`, `blast`) are executed as 
separate `RUN` commands so that these get cached as intermediate Docker layers.
This allows a single task to be tested quickly (by tag) by adding it at the 
end of the `Dockerfile-local`. If you want to run all steps from scratch, run
with the `--no-cache` option:

```
docker build --no-cache -t bioansible:latest -f docker/Dockerfile-local .
```

To build a production image by pulling the master branch:
```
docker build -t bioansible:latest -f docker/Dockerfile-repo .
```

We also have a Dockerfile for building a lighter-weight container than only
runs the RNAsik pipeline:

```
docker build -t rnasik:latest -f docker/Dockerfile-rnasik .
docker run -t rnasik:latest -help
```


## Building with Ansible Container

Install  [Ansible Container](https://www.ansible.com/ansible-container) 
(Hint: `pip install ansible-container[docker]`).

Run:
```
ansible-container build
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

Download BLAST databases

```BASH
cd /references/blast
sudo -u sw-installer $(which update_blastdb.pl) --passive --verbose '.*'
```
