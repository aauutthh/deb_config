#!/bin/bash
export PROJECT=deb_config
export PROGIT=${PROJECT}.git

[ $# -gt 0 ] || exit

script=$1
shift
export ARGV=$@

if [ ! -d $PROGIT ] ; then
  git clone --bare https://github.com/aauutthh/${PROGIT}
fi

[ -z "$D_RUN_ALREADY" ] || { echo "recursive call"; exit; }
 

(echo "set -- ${ARGV[@]} " '$@' ;
git --git-dir=$PROGIT show master:$script ) | /bin/bash

