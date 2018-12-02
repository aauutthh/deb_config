#!/bin/bash
export PATH=$PATH:/usr/sbin/:/sbin/
CURDIR=sudoers

[ $# -lt 1 ] && echo "arg username needed" &&  exit
DEBMAGIC=THIS_IS_GEN_BY_SCRIPT_github.com/aauutthh/deb_config.git

user=$1
nopasswdlst=$2
nopassfile=/etc/sudoers.d/nopassfile
userfile=/etc/sudoers.d/$user

if [ ! -z "$DEBUGING" ] ; then
    nopassfile=/tmp/$nopassfile
    userfile=/tmp/$userfile
    mkdir -p `dirname $nopassfile`
fi


cat_nopasswdlst() {
if [ ! -z "$nopasslst" -a -r "$nopasslst" ] ; then
    cat $nopasslst
else
    gitcat ${CURDIR}/nopasswd.lst
fi
}

create_nopass() {
    echo -n "Cmnd_Alias SUDOCMD = " > $nopassfile
    cat_nopasswdlst |
        while read cmd
        do
            which $cmd
        done | 
            perl -pe 's/\s*$/, /' >> $nopassfile
    echo " /bin/ls" >> $nopassfile
    chmod 600 $nopassfile

}

create_user() {
    if [ -e $userfile ] ; then
        grep $DEBMAGIC $userfile >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            mv $userfile $userfile.`date +%Y%m%d-%s`
        fi
    fi

    touch $userfile
    chmod 600 $userfile

    cat <<EOF > $userfile
# $DEBMAGIC
$user ALL=(ALL) ALL
$user ALL=(root) NOPASSWD: SUDOCMD
EOF
}

create_nopass
create_user
