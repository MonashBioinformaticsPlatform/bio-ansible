# Bio-Ansible 

> Simple way to configure your server remotely, one ansible instead of many `sudo apt-get install`s

## Content 

- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Extra files](#extra-files)
- [Adding more stuff](#adding-more-stuff)
- [Notes](#notes)
- [Manual handling](#manual-handling)

## Requirements

You need a [ansible](http://docs.ansible.com/ansible/index.html) installed locally

```BASH
sudo pip install ansible
```

You need to manually download some packages that require license agreements.  See `tarballs/README`

By default software will be installed to /software.  So, if you want this to be on a separate mount, set that up before running ansible.

So far this has only been developed on Ubuntu 14.04

## Quick start

```BASH
ansible-playbook -K -s -u powell -i hosts main.yml
```

or for only a specific task

```BASH
ansible-playbook -K -s -u powell -i hosts main.yml --tags samtools
```

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

You can refer to each role in your `playbook.yml` file as follow

```
- name: Testing the server
  hosts: bioinformatics
  remote_user: ubuntu

  roles:
          - common
          - bio_tools
```

And then execute your `playbook.yml` as follows

```
ansible-playbook -K -s -i hosts playbook.yml
```

You can add `-v` or `-vvv` options in for verbose, to get `stderr` messages printed out

Where your `hosts` file should look something link this

```
ansible-test ansible_ssh_host=146.118.99.235 ansiblee_ssh_port=22

[bioinformatics]
ansible-test
```

### Housekeeping 

- `main.yml` file are special, ansible looks for them by default
- please start evey `.yml` file with `---` at the top, for more [YMAL](http://www.yaml.org/spec/1.2/spec.html)

## Notes

According to [ansibel docs](http://docs.ansible.com/ansible/playbooks_intro.html)

> Modules are ‘idempotent’, meaning if you run them again, they will make only the changes they must in order to bring the system to the desired state. This makes it very safe to rerun the same playbook multiple times. They won’t change things unless they have to change things.

It is safe to re-run the same playbook.
