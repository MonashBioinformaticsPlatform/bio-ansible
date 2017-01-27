#!/bin/bash

make_user() {

  new_guy=$1
  guys_email=$2

  if ! grep -q $new_guy /etc/passwd
  then
    made_rand=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7`
    made_pass=`mkpasswd --method=sha-256 $made_rand`
    user_group="unknown"
    useradd --password $made_pass \
            --create-home \
            --shell /bin/bash \
            "$new_guy"
    echo "This is your username $new_guy and randomly generate password $made_rand. You are strongly encouraged to change it. You can do so by running passwd command and following the prompts \
                                     \
          Not a lab guy" | mail -s "Your login details for upcoming course by Monash Bioinforamtics Platform" $guys_email
    echo "$new_guy,$guys_email,$made_rand,new"
  else
    >&2 echo "MESSAGE: Bad username $new_guy"
    echo "$new_guy,$guys_email,-,current"
  fi

  unset new_guy
  unset guys_email
}

run_through() {

  input_file=$1

  while read dude email pass_word user_status
  do
    if [[ -z $user_status ]]
    then
        make_user $dude $email
    elif [[ $user_status == "current" ]]
    then
        make_user $dude $email
    elif [[ $user_status == "new" ]]
    then
      echo "$dude,$email,$pass_word,$user_status"
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

IFS=$old_ifs

unset old_ifs
unset make_user
unset run_through
