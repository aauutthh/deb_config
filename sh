export PROJECT=deb_config
export PROGIT=${PROJECT}.git

[ $# -gt 0 ] || exit

if [ ! -d $PROGIT ] ; then
  git clone --bare https://github.com/aauutthh/${PROGIT}
fi

[ ! -z "$SHELL" ] || SHELL=/bin/bash
[ -z "$D_RUN_ALREADY" ] || { echo "recursive call"; exit; }
 
exec git --git-dir=$PROGIT show master:$1|cat  #$SHELL

