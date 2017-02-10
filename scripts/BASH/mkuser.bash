

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
  guys_fullname=$4

  if ! grep -q $new_guy /etc/passwd
  then
    >&2 echo "MESSAGE: Username $new_guy doesn't exists"
    made_rand=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c7`
    made_pass=`mkpasswd --method=sha-256 $made_rand`
    #user_group="unknown"
    sudo useradd --password $made_pass \
                 --create-home \
                 --comment $guys_fullname \
                 --shell /bin/bash \
                 "$new_guy"
    #echo sudo useradd --password $made_pass \
    #             --create-home \
    #             --comment $guys_fullname \
    #             --shell /bin/bash \
    #             "$new_guy"
    send_out $new_guy $guys_email $guys_hostname $made_rand
  else
    >&2 echo "MESSAGE: Username $new_guy is a current user"
    current_guy="current"
  fi
}

del_user() {

  old_guy=$1
  if [[ -n $old_guy ]]
  then
    sudo passwd --delete $old_guy
    sudo deluser --remove-home \
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
  users_ifs=$3

  if [[ -n $input_user_file && -n $input_hostname ]]
  then

    while IFS=$ifs read user_name user_email user_status pass_word
    do
      # skip blank lines
      # to be exact skip lines which don't have user_name or user_email
      if [[ -z $user_name && -z $user_email ]]
      then
          continue
      fi

      clean_user=`echo $user_name | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | LANG=C sed 's/[^[:print:]]//' | sed 's/\./-/g'`
      clean_email=`echo $user_email | tr '[:upper:]' '[:lower:]' | sed -e 's/\r$//g' | LANG=C sed 's/[^[:print:]]//'`
      users_fullname=`echo "${clean_email%%\@*}" | sed 's/\./-/g'`

      if [[ -z $user_name ]]
      then
        user_name=$users_fullname
      fi

      if [[ -z $user_status || $user_status == "ToBeNew" ]]
      then
        make_user $user_name $user_email $input_hostname $users_fullname
        if [[ $current_guy != "current" ]]
        then
          echo "$user_name,$user_email,new,$made_rand"
        else
          echo "$user_name,$user_email,current,-"
        fi
      elif [[ $user_status == "current" || $user_status == "new" || $user_status == "changed" ]]
      then
        echo "$user_name,$user_email,current,-"
      elif [[ $user_status == "ToBeDeleted" ]]
      then
        del_user $user_name
        echo "$user_name,$user_email,deleted,-"
      elif [[ $user_status == "ToBeChanged" ]]
      then
        change_pass $user_name $user_email $input_hostname
        echo "$user_name,$user_email,changed,-"
      elif [[ $user_status == "deleted" ]]
      then
        echo "$user_name,$user_email,$user_status,-"
      else
        >&2 echo "ERROR: This shouldn't have happened: line 100"
      fi
    done < $input_user_file

  else
    >&2 echo "ERROR: This shouldn't have happened, check function"
  fi
  # variables from make_user function
  unset new_guy
  unset guys_email
  unset made_rand
  unset made_pass
  unset current_guy
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
  echo "  Usage: mkuser [OPTIONS] < --filename FILE --host STRING > "
  echo ""
  echo "  Options: "
  echo ""
  echo "           -F (--filename) <FILE> - provide file with user infomation"
  echo "           -H (--host) <STRING> - provide host name or IP address"
  echo "           -L (--linkdata) - will symlink /data/bio-data to user's home directory"
  echo "           --ifs [,] - set IFS (internal field separator)"
  echo ""
  echo " Description: "
  echo ""
  echo "           -F (--filename) takes a file with at least two columns, user_name,user_email "
  echo "           default CSV file type, use --ifs to set different separator "
  echo ""
  echo "           file format: "
  echo ""
  echo "              user_name,user_email,key_word,pass_word  "
  echo ""
  echo "           user_name - optional, have to be unique on the system, can do this ,user_email NOTE: leading comma "
  echo "           user_email - self explanatory, if no user_name, everything before @ is used as a user_name "
  echo "           key_words - there are two types; informative and actions" 
  echo ""
  echo "              Actions: "
  echo "                    > ToBeNew  - to indicate that user needs to be created, this is the same as leaving blank"
  echo "                    > ToBeChanged - to change users password, will send new email and password"
  echo "                    > ToBeDeleted - will permanently delete user and all relevant files"
  echo ""
  echo "              Informative: "
  echo "                    > new - new user had been created"
  echo "                    > current - the user is current, hint: a way to spot duplicated usernames"
  echo "                    > changed - user's password had been changed"
  echo "                    > deleted - user had been deleted permanently "
  echo ""
  echo "           pass_word - only used to output randomly generated password, can't use it to set any password"
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
      ifs=$2
      shift
      ;;
  esac
  shift
done

if [[ -z $ifs ]]
then
  ifs=,
fi

>&2 echo "MESSAGE: You'll need sudo to run this script!"

if [[ -f $username_file && -s $username_file && -n $your_host ]]
then
  make_users $username_file $your_host $ifs
  if [[ -n $link_data ]]
  then
    do_data_link
  fi
elif [[ -n $link_data ]]
then
  do_data_link
else
  >&2 echo "ERROR: Check your input file --filename and/or --host"
  exit 1
fi

# cmd variables
unset link_data
unset your_host
unset username_file
#make_user
unset new_guy
unset guys_email
unset guys_hostname
unset guys_fullname
unset made_rand
unset made_pass
# send_out
unset this_guy
unset his_email
unset his_hostname
unset his_pass
# del_user
unset old_guy
# change_pass
unset change_guy
unset change_email
unset change_hostname
unset new_rand
# makeusers
unset input_user_file
unset input_hostname
unset users_ifs
unset users_fullname
unset clean_user
unset clean_email
unset current_guy
# data_link
unset data_dirs
#unset functions
unset send_out
unset make_users
unset do_data_link
unset do_help
unset change_pass
unset del_user
