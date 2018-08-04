#!/bin/bash
echo $@ | aspell -a | head -n 2 | tail -n 1 | sed s/'\& \([^ ]*\) \([0-9]*\) \([0-9]*\): \(.*\)'/'I found \2 suggestions for \1: \4'/ | sed s/'# \([^ ]*\) \([0-9]*\)'/"Sorry, I couldn't find any suggestions for \1."/ | sed s/'\*'/"$@ is spelled correctly."/
