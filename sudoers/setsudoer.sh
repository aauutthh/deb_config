#!/bin/bash
export PATH=$PATH:/usr/sbin/:/sbin/
CURDIR=origin/master:sudoers

git --git-dir=${PROGIT} $CURDIR/nopasswd.lst |
while read cmd
do
  echo $cmd
done
