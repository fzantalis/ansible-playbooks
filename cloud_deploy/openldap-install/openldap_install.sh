#!/bin/sh
echo 'Enter Ldap Passowrd and press [ENTER]:'
read LDAPPASS
echo 'Enter server s hostname and press [ENTER]:'
read HOSTNAME
sudo apt-get install slapd ldap-utils phpldapadmin -y
echo '\nAnswer the following sldap config prompts like this:\nNO\nserver1\n"$HOSTNAME"\npassword\npassword\nHDB\nNO\nYes\nNO\n'
echo 'Write down the above configurations and press [ENTER] to continue...\n'
read PRESSTOCON
sudo dpkg-reconfigure slapd
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ldifs/log.ldif
echo '\nAnswer the following ldap config prompts like this: \nldap://127.0.0.1\dc="$HOSTNAME"\n3\nYes\nNo\ncn=admin,dc=server1\npassword\n'
echo 'Write down the above configurations and press [ENTER] to continue...\n'
read PRESSTOCON
sudo apt-get install libnss-ldap
sudo auth-client-config -t nss -p lac_ldap
echo 'Mark both options ( Unix Authentication, LDAP Authentication ) at the following prompt and press [ENTER] to continue...\n'
read PRESSTOCON
sudo pam-auth-update
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ldifs/indices.ldif
ldapadd -x -D cn=admin,dc=$HOSTNAME -w $LDAPPASS -f ldifs/basic1.ldif
ldapadd -x -D cn=admin,dc=$HOSTNAME -w $LDAPPASS -f ldifs/basic2.ldif
echo 'adding test user'
ldapadd -x -D cn=admin,dc=$HOSTNAME -w $LDAPPASS -f ldifs/user4.ldif
#sudo sed -i 's/example\.com/server1/g' /etc/phpldapadmin/config.php

