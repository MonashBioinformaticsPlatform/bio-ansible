FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y install python python3 python-pip python-virtualenv python3-pip python3-virtualenv \
                       git openjdk-8-jdk-headless ant golang-go unzip \
                       zlib1g-dev libncurses-dev libbz2-dev liblzma-dev \
                       tcl lua5.2 liblua5.2-dev lua-filesystem lua-posix lua-posix-dev && \
    apt-get -y clean && \
    pip install -U "pip==9.0.3" && \
    pip install -U "ansible<2.5"
# RUN git clone https://github.com/MonashBioinformaticsPlatform/bio-ansible.git
ADD . /bio-ansible/
WORKDIR /bio-ansible

RUN rm -f /bio-ansible/ansible.cfg

# We add a pre-prepared host_vars/localhost that overrides some default
# variables for nicer paths inside the Docker container
ADD ./docker/host_vars/localhost /bio-ansible/host_vars/localhost

# TODO: bio-ansible should really do this itself
RUN mkdir -p /bioansible/software/modules
RUN mkdir -p /bioansible/software/source
RUN mkdir -p /bioansible/software/apps

RUN ansible-playbook -vvv -c local -i hosts common.yml --tags lmod_etc,environment && \
    ansible-playbook -vvv -c local -i hosts bio.yml --tags lmod && \
    ansible-playbook -vvv -c local -i hosts bio.yml --tags bds && \
    ansible-playbook -vvv -c local -i hosts bio.yml --tags rnasik,star,subread,samtools,htslib,bedtools,picard,qualimap,fastqc,multiqc,bwa,hisat2 && \
    rm -rf /bio-ansible && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY docker/rnasik_wrapper.sh /bioansible/software/apps/rnasik.sh
RUN chmod +x /bioansible/software/apps/rnasik.sh
ENTRYPOINT ["/bioansible/software/apps/rnasik.sh"]
