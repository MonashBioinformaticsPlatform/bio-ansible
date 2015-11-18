# Bio-Ansible 

> Simple way to configure your server remotely, one ansible instead of many `sudo apt-get install`s

## Content 

- [Requirements](#requirements)
- [General notes](#general-notes)
- [Quick start](#quick-start)
- [Extra files](#extra-files)
  - [Manual handling](#manual-handling)
  - [Manual scripts](#manual-scripts)
- [Adding more stuff](#adding-more-stuff)

## Requirements

You need a [ansible](http://docs.ansible.com/ansible/index.html) installed locally

```BASH
sudo pip install ansible
```

## General notes

According to [ansible docs](http://docs.ansible.com/ansible/playbooks_intro.html)

> Modules are ‘idempotent’, meaning if you run them again, they will make only the changes they must in order to bring the system to the desired state. This makes it very safe to rerun the same playbook multiple times. They won’t change things unless they have to change things.

It is safe to re-run the same playbook.

Please note you can control what gets executed where through `hosts` file but bear in mind that `all` inside `playbook.yml` files under `hosts: all` means all servers ! I think you can specify multiple hosts/groups separating them by space

By default software will be installed under root `/software` directory.

So far this has only been developed on Ubuntu 14.04 (Trusty)

## Quick start

Given that you have access to the server and you have your ssh keys set up, it will be just the matter of running this line:

```BASH
ansible-playbook -i hosts playbook.yml
```

Or if you only after particular task

```BASH
ansible-playbook -i hosts main.yml --tags samtools
```

You can add `-v` or `-vvv` options in for verbose, to get `stderr` messages printed out

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

## Adding more stuff

The `roles/` directory hierarchy as follows

```
roles/
    make_sw_guy/
        tasks/
            main.yml
    common/
        tasks/
            main.yml
            *.yml
        templates/
            *.js2
    bio_tools/
        tasks/
            main.yml
            *.yml
        templates/
            *.js2
        files/
            *.zip
            *.tar.bz2
    nginx/
        tasks/
            main.yml
        templates/
            *.js2
    interactive/
        tasks/
            main.yml
            *.yml
    server_update/
        tasks/
            main.yml
```

You can refer to each role in your `playbook.yml` file as follows

```
- name: Testing the server
  hosts: bioinformatics
  remote_user: ubuntu

  roles:
          - common
          - bio_tools
```

Where your `hosts` file should look something link this

```
ansible-test ansible_ssh_host=146.118.99.235 ansiblee_ssh_port=22

[bioinformatics]
ansible-test
```

### Housekeeping 

- `main.yml` is a special file, ansible will assume default behaviour from it.
- please start every `.yml` file with `---` at the top, for more [YAML](http://www.yaml.org/spec/1.2/spec.html)

