FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y install python python3 python-pip python-virtualenv python3-pip python3-virtualenv git && \
    apt-get -y clean && \
    pip install -U "pip==9.0.3" && \
    pip install -U "ansible<2.5"
WORKDIR /bio-ansible
ADD . /bio-ansible/

RUN rm -f /bio-ansible/ansible.cfg

# TODO: bio-ansible should really do this itself
RUN mkdir -p /bioansible/software/modules
RUN mkdir -p /bioansible/software/source
RUN mkdir -p /bioansible/software/apps

# We add a pre-prepared host_vars/localhost that overrides some default
# variables for nicer paths inside the Docker container
ADD ./docker/host_vars/localhost /bio-ansible/host_vars/localhost

RUN ansible-playbook -vvv -c local -i hosts common.yml --tags timezone,apt && \
    ansible-playbook -vvv -c local -i hosts common.yml --tags pip,pip3 && \
    ansible-playbook -vvv -c local -i hosts common.yml --skip-tags apt,pip,pip3 && \
    ansible-playbook -vvv -c local -i hosts bio.yml --tags r_base,r_extras && \
    ansible-playbook -vvv -c local -i hosts bio.yml --skip-tags r_base,r_extras && \
    rm -rf /bio-ansbile && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
