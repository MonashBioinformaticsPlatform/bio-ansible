# Bio-Ansible 

> Simple way to configure your server remotely, one ansible instead of many `sudo apt-get install`s

## Content 

- [Requirements](#requirements)
- [Example to run](#example-to-run)
- [Extra files](#extra-files)
- [Adding more stuff](#adding-more-stuff)
- [Notes](#notes)

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

The `roles/` directory hierarchy as follows

```
roles/
    
    common/
        
        tasks/

            main.yml
            *.yml

        templates/

    bio_tools/

        tasks/

            main.yml
            *.yml

        templates/

    nginx/

        tasks/

            main.yml

        templates/

    interactive/

        tasks/

            main.yml
            *.yml

    server_update/

        tasks/

            main.yml
```

You can refere to each role in your `playbook.yml` file as follow

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
ansible-playbook -vvvv -K -s -i hosts playbook.yml
```

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

According to [ansiblel docs](http://docs.ansible.com/ansible/playbooks_intro.html)

> Modules are ‘idempotent’, meaning if you run them again, they will make only the changes they must in order to bring the system to the desired state. This makes it very safe to rerun the same playbook multiple times. They won’t change things unless they have to change things.

It is safe to re-run the same playbook.
