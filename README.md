# Bio-Ansible 

> Simple way to configure your server remotely, one ansible instead of many `sudo apt-get install`s

## Content 

- [Quick start](#quick-start)
- [Introduction](#introduction)
- [Extra files](#extra-files)
  - [Manual handling](#manual-handling)
  - [Manual scripts](#manual-scripts)

## Quick start

Assume you know how to start new [virtual machine (vm)](https://en.wikipedia.org/wiki/Virtual_machine) instance and how to install and operate [ansible](http://docs.ansible.com/ansible/intro.html).

- bring up a vm (AWS, NeCTAR, OpenStack, etc)

_depending on how you want to run this playbook the order of the next couple of steps will change, but I can see you are a smart cookie, so you'll be fine_

- set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
- edit `host` file to add vm ip address, edit `groups_vars/all` files to change vm username
- [run ansible](#running-ansible)
```BASH
ansible-playbook -i hosts all.yml
```
- all done !

## Introduction

This ansible script is multi-potent as it can set up from scratch the whole army of server for bioinformatics (genomic focused) work or this ansible can be used to install selected tools only. This ansible script can be used by user without `sudo` privilege for installing tools, this assuming all of the common dependencies have been installed (which is usually the case on the running server). If you are missing some or all of the dependencies point your system administrator [to these dependencies](roles/common/tasks/main.yml) plus Java 8. One can use `common.yml` to install all of the dependencies at once.

Also note that modules are ‘idempotent’, meaning if you run them again, they will make only the changes they must in order to bring the system to the desired state. This makes it very safe to rerun the same playbook multiple times. They won’t change things unless they have to change things.

**It is safe to re-run the same playbook**

#### Running ansible

1. [Install ansible](http://docs.ansible.com/ansible/intro_installation.html)
2. set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
3. `git clone https://github.com/serine/bio-ansible.git`
4. edit `hosts` file to include your IP address
5. edit `group/all` file to include your username as `main_guy` variable
6. To install:

    - everything you'll need `sudo` privilege

    ```
    ansible-playbook -i hosts all.yml
    ```

    - just the tools - don't need `sudo`

    ```
    ansible-playbook -i hosts bio.yml
    ```

    - just the dependencies - need `sudo`

    ```
    ansible-playbook -i hosts common.yml
    ```

7. Alternatively you can install only particular tool

```BASH
ansible-playbook -i hosts main.yml --tags get_samtools,build_samtools
```

_You can always add `-v` or `-vvv` options for verbose mode_


## Extra files

### Manual handling

You need to manually download these packages and place them into `roles/bio_tools/files/` directory.
The `playbook.yml` going to skip installation of those packages if it doesn't find archived files in files directory.

- http://www.broadinstitute.org/software/igv/download

    - IGV_2.3.42.zip
    - igvtools_2.3.42.zip

- https://www.broadinstitute.org/gatk/download/auth?package=GATK

    - GenomeAnalysisTK-3.3-0.tar.bz2

### Manual scripts

There are scripts to download various databases in `scripts/`. These have deliberately not been added to ansible.

Download blast databases

```BASH
cd /references/blast
sudo -u sw-installer $(which update_blastdb.pl) --passive --verbose '.*'
```
