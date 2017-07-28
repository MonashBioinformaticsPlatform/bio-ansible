#!/usr/bin/env bash
URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
while true; do
    read -p "Type 'yes' to confirm you agree to the license here: http://www.oracle.com/technetwork/java/javase/terms/license/index.html: " yn
    case $yn in
        [Yy]es ) wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" "${URL}"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer the full word yes (or no).";;
    esac
done


