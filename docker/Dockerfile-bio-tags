FROM ubuntu:18.04

ARG TASK_TAGS=seqtk

RUN apt-get -y update && \
    apt-get -y install python python3 python-pip python-virtualenv python3-pip python3-virtualenv \
                       build-essential git zlib1g-dev default-jre-headless ant cpanminus && \
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

RUN ansible-playbook -vvv -c local -i hosts bio.yml --tags $TASK_TAGS

RUN rm -rf /bio-ansbile && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
