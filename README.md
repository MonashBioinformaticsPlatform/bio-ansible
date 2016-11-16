Requirements
--

You need a `ansible` installed locally

    sudo pip install ansible
    
You need to manually download some packages that require license agreements.  See `tarballs/README`

By default software will be installed to /mnt/software.  So, if you want this to be on a separate mount, set that up before running ansible.

So far this has only been developed on Ubuntu 14.04

Example to run
--

    ansible-playbook -K -s -u powell -i hosts main.yml

or for only a specific task

    ansible-playbook -K -s -u powell -i hosts main.yml --tags samtools

or for only a specific host

    ansible-playbook -K -s -u powell -l bio1 -i hosts main.yml --tags samtools



Extra files
--

There are scripts to download various databases in `scripts/`. These have deliberately not been added to ansible.

Download blast databases

    cd /references/blast
    sudo -u sw-installer $(which update_blastdb.pl) --passive --verbose '.*'


