#!/bin/bash
if [ ! -d worlds/enabled ]; then
	exit
fi
for i in `ls worlds/enabled/*.world`; do
	echo $1 "`cat $i | sed s/'.*addworld("\([^"]*\)".*'/'\1'/` "
done
if [ "$1" == "-n" ]; then
	echo
fi
