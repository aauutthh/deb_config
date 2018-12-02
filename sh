#!/bin/bash

# entry of the script
# check arguments
# check no recursive
entry_check() {
    [ $# -gt 0 ] || exit

    [ -z "$D_RUN_ALREADY" ] || { echo "recursive call"; exit; }
    D_RUN_ALREADY="run"
}


clone_bare_git() {
    local  progurl
    progurl=$1
    if [ ! -d $PROGIT ] ; then
        git clone --bare $progurl
        cd $PROGIT
        git config --add remote.origin.url $progurl
        git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
        git fetch 
        cd -
    else
        cd $PROGIT
        git fetch 
        cd -
    fi
}

## start of script
entry_check $@
export PROJECT=deb_config
export PROGIT=${PROJECT}.git
script=$1
shift
export ARGV=$@
PROURL=https://github.com/aauutthh/${PROGIT}

if [ -z $DEB_CONFIG_DEBUG_URL ] ; then
  clone_bare_git $PROURL
else
  clone_bare_git $DEB_CONFIG_DEBUG_URL
  export DEBUGING="1"
fi


util=/tmp/.$PROGIT.util
export REV=origin/master
if [ ! -z $DEB_CONFIG_DEBUG_REV ] ; then
    REV=$DEB_CONFIG_DEBUG_REV
fi
cat <<-EOF  > $util
gitcat () {
  if [ \$# -gt 0 ] ; then
    git --git-dir=${PROGIT} show ${REV}:\$1
  fi
}
EOF

#sed -i -e "s/\${PROGIT}/$PROGIT/g" $util
#sed -i -e "s/\${REV}/$REV/g" $util

(echo "set -- ${ARGV[@]} " '$@' ;
echo ". $util" ;
git --git-dir=$PROGIT show ${REV}:$script ) | /bin/bash

rm $util
