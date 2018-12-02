#!/bin/bash
export PATH=$PATH:/usr/sbin/:/sbin/

while read cmd
do
  echo $cmd
done < ./nopasswd.lst
