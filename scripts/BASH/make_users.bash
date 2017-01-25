#!/bin/bash

make_user() {

  made_pass=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7 | mkpasswd --stdin`
  #user_group="unknown"
  #useradd --password $made_pass \
  #        --create-home \
  #        --shell /bin/bash \
  #        "$new_guy"
}

new_guy=""

echo "This is input $1 file"

while read line
do
  make_user
  echo "$line,$made_pass" >> users_list.txt
done < $1

unset made_pass
