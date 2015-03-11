Example to run

    ansible-playbook -K -s -u powell -i hosts main.yml

or for only a specific task

    ansible-playbook -K -s -u powell -i hosts main.yml --tags samtools


There are scripts to download various databases in `scripts/`. These have deliberately not been added to ansible.

So far this has only been developed on ubuntu 14.04
