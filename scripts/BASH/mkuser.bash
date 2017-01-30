
# global variables
old_ifs=$IFS
IFS=,

check_user() {
  check_guy=$1
  new_guy=""

  if ! grep -q $check_guy /etc/passwd
  then
    new_guy=$check_guy
    >&2 echo "MESSAGE: Username $new_guy doesn't exists"
  else
    >&2 echo "MESSAGE: Username $check_guy is a current user"
  fi
}

send_out() {
    
  echo -e "This is your username $new_guy and randomly generate password $made_rand. \n You are strongly encouraged to change it. You can do so by running \`passwd\` command and following the prompts \n \n Not a lab guy" | mail -s "Your login details for upcoming course by Monash Bioinforamtics Platform" $user_mail
}

make_user() {

  check_user $1
  user_mail=$2

  if [[ -n $new_guy ]]
  then
    made_rand=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7`
    made_pass=`mkpasswd --method=sha-256 $made_rand`
    #user_group="unknown"
    sudo useradd --password $made_pass \
                 --create-home \
                 --shell /bin/bash \
                 "$new_guy"
    >&2 echo "MESSAGE: You'll need sudo to run this script!"
    echo "$new_guy,$user_mail,new,$made_rand"
    send_out
  else
    #>&2 echo "MESSAGE: Bad username $new_guy"
    echo "$new_guy,$user_mail,current,-"
  fi

  unset new_guy
  unset user_name
  unset user_mail
  unset check_guy
  unset made_rand
  unset made_pass
}

del_user() {
  old_guy=$1

  if [[ -n $old_guy ]]
  then
    if [[ $EUID == 0 ]]
    then
      userdel --remove $old_guy
      >&2 echo "MESSAGE: Username $old_guy had been removed from the system, including howe directory"
    else
      >&2 echo "ERROR: Are you running this script as root? You sould be !"
    fi
  fi
}

make_users() {

  input_file=$1

  while read user_name user_mail user_status pass_word
  do
    if [[ -z $user_status ]]
    then
        make_user $user_name $user_mail
    elif [[ $user_status == "current" ]]
    then
      echo "$user_name,$user_mail,$user_status,-"
    elif [[ $user_status == "new" ]]
    then
      make_user $user_name $user_mail
      echo "$user_name,$user_mail,$user_status,$pass_word"
    elif [[ $user_status == "old" ]]
    then
      del_user $user_name
      echo "$user_name,$user_mail,old,-"
    else
      >&2 echo "ERROR: This shouldn't have happend"
    fi

  done < $input_file
  
}


mkuser() {

  if [[ -z "$@" ]]
  then
    mkuser -h
  fi
  
  while [[ $# -gt 0 ]]
  do
    key="$1"
  
    case $key in
      (-h|--help)
        echo ""
        echo "  Version: 0.1.2"
        echo "  Usage: mkuser [OPTIONS] < --filename FILE > "
        echo ""
        echo "  Options: "
        echo ""
        echo "           -f (--filename) <FILE> - provide file with user infomation"
        #echo "           -s (--show) - show user(s) status on the machine"
        #echo "           -n (--newpass) - generate new random password for user(s)"
        #echo "           -d (--delete) - remove user(s) from the system" 
        echo "           --ifs [,] - set IFS (internal field separator)"
        echo ""
        shift
        ;;
      (-f|--filename)
        if [[ -f $2 && -s $2 ]]
        then
          make_users $2
        else
          >&2 echo "ERROR: Check your input file --filename $2"
        fi
        shift
        ;;
      (--ifs)
        IFS=$3
        shift
        ;;
    esac
    shift
  done
}

#IFS=$old_ifs
#
#unset old_ifs
#unset check_user
#unset send_out
#unset make_user
#unset make_users
#unset main

