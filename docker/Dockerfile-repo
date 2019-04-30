FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y install python python3 python-pip python-virtualenv python3-pip python3-virtualenv git && \
    apt-get -y clean && \
    pip install -U "pip==9.0.3" && \
    pip install -U "ansible<2.5"

RUN git clone https://github.com/MonashBioinformaticsPlatform/bio-ansible.git && \
    cd bio-ansible && \
    ansible-playbook -vvv -i hosts common.yml && \
    ansible-playbook -vvv -i hosts bio.yml --skip-tags gatk,java_oracle,cell_ranger && \
    rm -rf /bio-ansible && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
