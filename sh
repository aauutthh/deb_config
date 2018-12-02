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

util=/tmp/.$PROGIT.util
cat <<'EOF'  > $util
gitcat () {
  if [ $# -gt 0 ] ; then
    git --git-dir=${PROGIT} show origin/master:$1
  fi
}
EOF

sed -i -e "s/\${PROGIT}/$PROGIT/g" $util

(echo "set -- ${ARGV[@]} " '$@' ;
echo ". $util" ;
git --git-dir=$PROGIT show origin/master:$script ) | /bin/bash

rm $util
