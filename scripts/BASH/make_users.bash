
# global variables
old_ifs=$IFS
IFS=,

send_out() {

  this_guy=$1
  his_email=$2
  his_hostname=$3
  his_pass=$4
    
  #echo -e "This is your login details, note you were given randomly generated password. You are strongly encouraged to change it. You can do so by running \`passwd\` command and following the prompts. \n \n username: $new_guy \n password: $made_rand \n host: biotraining.erc.monash.edu \n \n To connect to the server use \`ssh\` command \n \n  \`ssh $new_guy@$your_host\` \n \n Not a lab guy" | mail -s "Your login details for upcoming course by Monash Bioinforamtics Platform" $user_mail
  echo -e "This is your login details below: \n \n username: $this_guy \n password: $his_pass \n host: $his_hostname \n \n To connect to the server use \`ssh\` command \n \n  \`ssh $this_guy@$his_hostname\` \n \n If you have any problems email Kirill at kirill.tsyganov@monash.edu" | mail -s "Your login details for upcoming course by Monash Bioinforamtics Platform" $his_email

}

make_user() {

  new_guy=$1
  guys_email=$2
  guys_hostname=$3

  if ! grep -q $new_guy /etc/passwd
  then
    >&2 echo "MESSAGE: Username $new_guy doesn't exists"
    made_rand=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7`
    made_pass=`mkpasswd --method=sha-256 $made_rand`
    #user_group="unknown"
    sudo useradd --password $made_pass \
                 --create-home \
                 --shell /bin/bash \
                 "$new_guy"
    echo "$new_guy,$guys_email,new,$made_rand"
    send_out $new_guy $guys_email $guys_hostname $made_rand
  else
    >&2 echo "MESSAGE: Username $new_guy is a current user"
    echo "$new_guy,$guys_email,current,-"
  fi
}

del_user() {

  old_guy=$1

  if [[ -n $old_guy ]]
  then
    passwd --delete $old_guy

    deluser --remove-home \
            --remove-all-files \
            $old_guy

    >&2 echo "MESSAGE: Username $old_guy had been removed from the system, including howe directory"
  fi
}

change_pass() {
  change_guy=$1
  change_email=$2
  change_hostname=$3
  new_rand=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7`

  if [[ -n $change_guy ]]
  then
    echo "$change_guy:$new_rand" | sudo chpasswd --crypt-method SHA256
    send_out $change_guy $change_email $change_hostname $new_rand
  fi
}

make_users() {

  input_user_file=$1
  input_hostname=$2

  if [[ -n $input_user_file && -n $input_hostname ]]
  then

    while read user_name user_mail user_status pass_word
    do
      if [[ -z $user_status ]]
      then
          make_user $user_name $user_mail $input_hostname
      elif [[ $user_status == "current" ]]
      then
        echo "$user_name,$user_mail,$user_status,-"
      elif [[ $user_status == "new" ]]
      then
        make_user $user_name $user_mail $input_hostname
        echo "$user_name,$user_mail,$user_status,$pass_word"
      elif [[ $user_status == "ToBeDeleted" ]]
      then
        del_user $user_name
        echo "$user_name,$user_mail,deleted,-"
      elif [[ $user_status == "ToBeChanged" ]]
      then
        change_pass $user_name $user_mail $input_hostname
        echo "$user_name,$user_mail,changed,-"
      elif [[ $user_status == "deleted" || $user_status == "changed" ]]
      then
        echo "$user_name,$user_mail,$user_status,-"
      else
        >&2 echo "ERROR: This shouldn't have happened: line 100"
      fi
    done < $input_user_file
  else
    >&2 echo "ERROR: This shouldn't have happened, check make_users function"
  fi
  # variables from make_user function
  unset new_guy
  unset guys_email
  unset made_rand
  unset made_pass
  # variables from this function
  unset input_user_file
  unset input_host_file
  # unset function
  unset make_user
}

do_data_link() {
  data_dirs=(r-intro-gh-pages/r-intro-files r-more-gh-pages/r-more-files RNAseq-DE-analysis-with-R-gh-pages/data)
  
  for u in /home/*
  do 
    for dd in ${data_dirs[@]}
    do
      if [[ ! -L "$u/$(basename $dd)" ]]
      then
        ln -s /data/bio-data/$dd $u/
        chown -R $(basename $u):$(basename $u) $u/$(basename $dd)
        >&2 echo "MESSAGE: Linked $dd to $u"
      else
        >&2 echo "MESSAGE: Username $(basename $u) already has $dd symlink"
      fi
    done
  done
}

do_help() {

  echo ""
  echo "  Version: 0.1.2"
  echo "  Usage: mkuser [OPTIONS] < --filename FILE > "
  echo ""
  echo "  Options: "
  echo ""
  echo "           -F (--filename) <FILE> - provide file with user infomation"
  echo "           -H (--host) <STRING> - provide host name or IP address"
  echo "           -L (--linkdata) - will symlink /data/bio-data to user's home directory"
  #echo "           -s (--show) - show user(s) status on the machine"
  #echo "           -n (--newpass) - generate new random password for user(s)"
  #echo "           -d (--delete) - remove user(s) from the system" 
  echo "           --ifs [,] - set IFS (internal field separator)"
  echo ""
  exit 1
}

if [[ "$#" == 0 ]]
then
  do_help
fi

while (( "$#" ))
do
  key="$1"

  case $key in
    (-h|--help)
      do_help
      ;;
    (-L|--linkdata)
      link_data=true
      ;;
    (-H|--host)
      your_host=$2 
      shift
      ;;
    (-F|--filename)
      username_file=$2
      shift
      ;;
    (--ifs)
      IFS=$2
      shift
      ;;
  esac
  shift
done

>&2 echo "MESSAGE: You'll need sudo to run this script!"

if [[ -f $username_file && -s $username_file ]]
then
  if [[ -n $your_host ]]
  then
    make_users $username_file $your_host
  else
    >&2 echo "ERROR: you need to specify host use --host"
    exit 1
  fi
else
  >&2 echo "ERROR: Check your input file --filename $2"
  exit 1
fi

if [[ -n $link_data ]]
then
  do_data_link
fi

# unset variables
unset link_data
unset your_host
unset username_file
# change_pass
unset change_guy
unset change_email
unset change_hostname
unset new_rand
# send_out
unset this_guy
unset his_email
unset his_hostname
unset his_pass
# del_user
unset old_guy
IFS=$old_ifs
#unset functions
unset send_out
unset make_users
unset do_data_link
unset do_help
unset change_pass
unset del_user
