#!/bin/bash
export PATH=$PATH:/usr/sbin/:/sbin/
CURDIR=origin/master:sudoers

gitcat sudoers/nopasswd.lst 
echo  "hello"
git --git-dir=${PROGIT} show $CURDIR/nopasswd.lst |
while read cmd
do
  echo $cmd
done
