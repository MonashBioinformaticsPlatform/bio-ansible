Requirements
--

You need a `ansible` installed locally

    sudo pip install ansible
    
You need to manually download some packages that require license agreements.  See `tarballs/README`

By default software will be installed to /software.  So, if you want this to be on a separate mount, set that up before running ansible.

On your target host(s), you must create a user sw-installer in the sudo group.

    server:~$ sudo adduser --ingroup sudo sw-installer

So far this has only been developed on Ubuntu 14.04

Example to run
--

    ansible-playbook -K -s -u powell -i hosts main.yml

or for only a specific task

    ansible-playbook -K -s -u powell -i hosts main.yml --tags samtools



Extra files
--

There are scripts to download various databases in `scripts/`. These have deliberately not been added to ansible.

Download blast databases

    cd /references/blast
    sudo -u sw-installer $(which update_blastdb.pl) --passive --verbose '.*'


