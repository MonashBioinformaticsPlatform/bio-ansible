# Bio-Ansible 

> Do bioinformatics not sys-admining - run the playbook and get back to work !

## Content 

- [Quick start](#quick-start)
- [Introduction](#introduction)
- [Running bio-ansible](#running-bio-ansible)
- [Extra files](#extra-files)
  - [Manual handling](#manual-handling)
  - [Manual scripts](#manual-scripts)

## Quick start

Assume you know how to start new [virtual machine (vm)](https://en.wikipedia.org/wiki/Virtual_machine) instance and how to install and operate [ansible](http://docs.ansible.com/ansible/intro.html).

- bring up a vm (AWS, NeCTAR, OpenStack, etc)
- set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
- edit `host` file to add vm ip address, edit `groups_vars/all` files to change vm username

```BASH
ansible-playbook -i hosts all.yml
```
## Introduction

This bio-ansible script is multi-potent as it can set up from scratch the whole army of servers with bioinformatics (genomic) focus or just install handful of selected tools. Depending on what you are trying to do you can run bio-ansible as a non privileged user, particular if you are just installing bio-tools. However you still might need to install some "common" dependencies and for that you might need `sudo`.

For more comprehensive playbook breakdown [read here](supplementary/playbook_breakdown.md)

Also note that modules are ‘idempotent’, meaning if you run them again, they will make only the changes they must in order to bring the system to the desired state. This makes it very safe to rerun the same playbook multiple times. They won’t change things unless they have to change things.

**It is safe to re-run the same playbook**

## Running bio-ansible

1. [Install ansible](http://docs.ansible.com/ansible/intro_installation.html)
2. set up your [ssh-keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
3. `git clone https://github.com/serine/bio-ansible.git`
4. edit `hosts` file to include your IP address into the right group
5. edit `group/all` file to include your username as `main_guy` variable
6. To install:
    - everything - need `sudo` privilege
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
ansible-playbook -i hosts main.yml --tags samtools
ansible-playbook -i hosts main.yml --tags star
ansible-playbook -i hosts main.yml --tags subread
```

OR

```BASH
ansible-playbook -i hosts main.yml --tags samtools,star,subread
```

_You can always add `-v` or `-vvv` options for verbose mode_

[Full list of available tags](supplementary/list_of_tags.md)

## Extra files

### Manual handling

Because of the licenses some installation files need to be manually downloaded into `tarballs` directory. [List of supported packages](tarballs)

You need to manually download these packages and place them into `roles/bio_tools/files/` directory.
The `playbook.yml` going to skip installation of those packages if it doesn't find archived files in files directory.

### Manual scripts

There are scripts to download various databases in `scripts/`. These have deliberately not been added to ansible.

Download blast databases

```BASH
cd /references/blast
sudo -u sw-installer $(which update_blastdb.pl) --passive --verbose '.*'
```
