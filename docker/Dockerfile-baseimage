FROM ubuntu:18.04

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales locales-all && \
    localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_AU.UTF-8 && \
    apt-get install -y python python3 python-pip python3-pip \
                       python-virtualenv python3-virtualenv \
                       build-essential git wget curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install -U "pip==9.0.3" && \
    pip install -U "ansible<2.5"


CMD ["/bin/bash"]
