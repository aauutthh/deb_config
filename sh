#!/bin/bash
export PROJECT=deb_config
export PROGIT=${PROJECT}.git

[ $# -gt 0 ] || exit

script=$1
shift
export ARGV=$@

if [ ! -d $PROGIT ] ; then
  git clone --bare https://github.com/aauutthh/${PROGIT}
  cd $PROGIT
  git config --add remote.origin.url http://github.com/aauutthh/${PROGIT}
  git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
  cd -
else
  cd $PROGIT
  git fetch 
  cd -
fi

[ -z "$D_RUN_ALREADY" ] || { echo "recursive call"; exit; }
 

(echo "set -- ${ARGV[@]} " '$@' ;
git --git-dir=$PROGIT show origin/master:$script ) | /bin/bash

