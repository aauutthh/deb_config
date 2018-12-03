#!/bin/bash -e

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
        echo -n "dir change  : "
        pushd $PROGIT 
        git config --add remote.origin.url $progurl
        git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
        git fetch 
        echo -n "backto : "
        popd
    else
        echo -n "dir change  : "
        pushd $PROGIT 
        git fetch 
        echo -n "backto : "
        popd
    fi
}

## start of script
entry_check $@
export PROJECT=deb_config
export PROGIT=${PROJECT}.git
export PROURL=https://github.com/aauutthh/${PROGIT}
export SCRIPT=$1
while [ $# -gt 0 ] ; do
    if [ "$1" == "--" ] ; then
        shift
        break
    fi
    shift
done
#declare ARGV=($@)
echo "parse args to script<$SCRIPT>:" $@


if [ -z $DEB_CONFIG_DEBUG_URL ] ; then
  clone_bare_git $PROURL
else
  clone_bare_git $DEB_CONFIG_DEBUG_URL
  export DEBUGING="1"
fi


export REV=origin/master
if [ ! -z $DEB_CONFIG_DEBUG_REV ] ; then
    REV=$DEB_CONFIG_DEBUG_REV
fi

sid=`git --git-dir=${PROGIT} log -1 --format="%h" ${REV} -- sh`

util=/tmp/util.$PROGIT.$sid
if [ ! -e $util ]  ; then
cat <<'EOF'  > $util
gitcat () {
  if [ $# -gt 0 ] ; then
    git --git-dir=${PROGIT} show ${REV}:$1
  fi
}
# 取commitid
gitsid() {
  git --git-dir=${PROGIT} log -1 --format="%h" ${REV} -- $1
}
EOF
fi

. $util

# 如果脚本存在于仓库则用仓库的脚本，否则使用本地脚本
catscript() {
    commit=`gitsid $1`
    if [ -n "${commit}" ] ; then
        gitcat $1
    else
        if [ -n "$DEBUGING" ] ; then
            cat $1
        fi
    fi
}

# 如果执行的是二进制文件?
(echo ". $util" ;
catscript $SCRIPT ) | /bin/bash -s -- $@

#rm $util
