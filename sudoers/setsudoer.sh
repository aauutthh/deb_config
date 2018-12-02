#!/bin/bash
export PATH=$PATH:/usr/sbin/:/sbin/
CURDIR=sudoers

[ $# -lt 1 ] && echo "arg username needed" &&  exit

user=$1
nopassfile=/etc/sudoers.d/nopassfile
userfile=/etc/sudoers.d/$user

if [ ! -z "$DEBUGING" ] ; then
    nopassfile=/tmp/$nopassfile
    userfile=/tmp/$userfile
    mkdir -p `dirname $nopassfile`
fi


create_nopass() {
    gitcat ${CURDIR}/nopasswd.lst |
        while read cmd
        do
            which $cmd
        done | 
            perl -pe 's/\s*$/,/'

     echo "Cmnd_Alias SUDOCMD = "
}

create_user() {
    if [ -e $userfile ] ; then
        grep $DEBMAGIC $userfile >/dev/null 2>&1
        if [ $? ]; then
            mv $userfile $userfile.`date +%Y%m%d-%s`
        fi
    fi

    touch $userfile
    chmod 600 $userfile

    cat <<EOF > $userfile
$user ALL=(ALL) ALL
$user ALL=(root) NOPASSWD: SUDOCMD
EOF
}

create_user
create_nopass
