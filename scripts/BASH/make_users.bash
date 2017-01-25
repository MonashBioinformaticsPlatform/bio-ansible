#!/bin/bash

make_user() {

  new_guy=$1

  if ! grep -q $new_guy /etc/passwd
  then
    made_rand=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7`
    made_pass=`mkpasswd --method=sha-256 $made_rand`
    #user_group="unknown"
    #useradd --password $made_pass \
    #        --create-home \
    #        --shell /bin/bash \
    #        "$new_guy"
    echo "$new_guy,$made_rand,new"
  else
    >&2 echo "MESSAGE: Bad username $new_guy"
    echo "$new_guy,-,current"
  fi
}

run_through() {

  input_file=$1

  while read dude pass_word user_status
  do
    if [[ -z $user_status ]]
    then
        make_user $dude
    elif [[ $user_status == "current" ]]
    then
        make_user $dude
    elif [[ $user_status == "new" ]]
    then
      echo "$dude,$pass_word,$user_status"
    else
      >2& echo "ERROR: This shouldn't have happend"
    fi

  done < $input_file
  
  unset made_rand
  unset made_pass
  unset new_guy
}

old_ifs=$IFS
IFS=,

run_through $1
