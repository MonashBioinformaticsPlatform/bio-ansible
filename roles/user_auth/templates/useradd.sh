#!/bin/bash
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
#LDAPUSER="steveand"
group="ldap-user"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -a|--authcate)
    EMAIL="$2"
    shift # past argument
    ;;
    -l|--ldap)
    LDAPUSER="$2"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ -z "${LDAPUSER}" ]
then
  echo "Set ldapuser"
  exit
fi

if [ -z ${EMAIL+x} ]
then
	echo "authcate is unset (use -a)"
	exit
else
    echo "Auth using $LDAPUSER"
	echo "Creating user for ${EMAIL}"; fi
	/usr/bin/ldapsearch -LLL -x -D "CN=${LDAPUSER},OU=People,OU=Accounts,OU=IdM Managed Objects,DC=AD,DC=MONASH,DC=EDU" -W -h ad.monash.edu -b "DC=AD,DC=Monash,DC=EDU" "(mail=${EMAIL})" DisplayName samaccountname uidNumber gidNumber unixHomeDirectory loginShell mail  |
  while IFS= read -r line
  do
    if [[ $line == uidNumber* ]]
	then
		linelen=`expr ${#line} - 11`
		uid=${line:11:linelen}
	fi
    if [[ $line == sAMAccountName* ]]
	then
		linelen=`expr ${#line} - 16`
		user=${line:16:linelen}
	fi
	
	if [ "$uid" ] &&  [ "$user" ]
	then
		echo "LDAP user id: ${uid} ${user}"
		echo "creating user.."
		/usr/sbin/adduser --disabled-password --home "/home/${user}" --shell /bin/bash --uid $uid --ingroup $group --gecos "${EMAIL}" $user
		break
	fi
  done
