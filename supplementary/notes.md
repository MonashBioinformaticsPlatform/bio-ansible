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

## Housekeeping 

- `main.yml` is a special file, ansible will assume default behaviour from it.
- please start every `.yml` file with `---` at the top, for more [YAML](http://www.yaml.org/spec/1.2/spec.html)

## Handy tips

#### RStudio 

- [configuring server](https://support.rstudio.com/hc/en-us/articles/200552316-Configuring-the-Server)
- [managing the server](https://support.rstudio.com/hc/en-us/articles/200532327-Configuring-the-Server)

- useful variable `RSTUDIO_WHICH_R` to set specific `R` version

#### General

- `dpkg -l "*studio*"` to see which debian package you have installed
