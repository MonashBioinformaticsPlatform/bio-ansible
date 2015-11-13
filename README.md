# Bio-Ansible 

> Simple way to configure your server remotely, one ansible instead of many `sudo apt-get install`s

## Content 

- [Requirements](#requirements)
- [Example to run](#example-to-run)
- [Extra files](#extra-files)
- [Adding more stuff](#adding-more-stuff)

## Requirements

You need a [ansible](http://docs.ansible.com/ansible/index.html) installed locally

```BASH
sudo pip install ansible
```

You need to manually download some packages that require license agreements.  See `tarballs/README`

By default software will be installed to /software.  So, if you want this to be on a separate mount, set that up before running ansible.

So far this has only been developed on Ubuntu 14.04

## Example to run

```BASH
ansible-playbook -K -s -u powell -i hosts main.yml
```

or for only a specific task

```BASH
ansible-playbook -K -s -u powell -i hosts main.yml --tags samtools
```


## Extra files

There are scripts to download various databases in `scripts/`. These have deliberately not been added to ansible.

Download blast databases

    cd /references/blast
    sudo -u sw-installer $(which update_blastdb.pl) --passive --verbose '.*'

## Adding more stuff

1. Make `.yml` file inside `tasks/` directory, describing what needs done
2. Include that `.yml` file in `main.yml` file using `include` statement
3. You are all good to go now !

## Notes

According to [ansiblel docs](http://docs.ansible.com/ansible/playbooks_intro.html)

> Modules are ‘idempotent’, meaning if you run them again, they will make only the changes they must in order to bring the system to the desired state. This makes it very safe to rerun the same playbook multiple times. They won’t change things unless they have to change things.

It is safe to re-run the same playbook.
