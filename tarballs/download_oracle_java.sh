#!/usr/bin/env bash
URL="http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz"
while true; do
    read -p "Type 'yes' to confirm you agree to the license here: http://www.oracle.com/technetwork/java/javase/terms/license/index.html: " yn
    case $yn in
        [Yy]es ) wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" "${URL}"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer the full word yes (or no).";;
    esac
done


