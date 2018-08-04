#!/bin/bash
CURFILE=.bot.sluggy.curr
LASTFILE=.bot.sluggy.last
PAGE=http://www.sluggy.com/
USERAGENT="NightMAREbot/1.0 (Wget/1.9.1; +http://mare.qbfreak.net/Main/SluggyNightMAREbot)"

pushd `dirname $0` >/dev/null
if [ -e $CURFILE ]; then
	mv $CURFILE $LASTFILE
fi
wget -A text -U $USERAGENT -q -O $CURFILE $PAGE
if [[ -s $CURFILE && -s $LASTFILE ]]; then
	CURIMG=`grep "/comics/" $CURFILE`
	LASTIMG=`grep "/comics/" $LASTFILE`
	if [ "$CURIMG" != "$LASTIMG" ]; then
		echo "NEWCOMIC"
	else
		DIFF=`diff $CURFILE $LASTFILE`
		if [ "$DIFF" != "" ]; then
			echo "UPDATE"
		else
			echo "NOCHANGE"
		fi
	fi
else
	if [ ! -s $CURFILE ]; then
		echo "NOPAGE"
	fi
	if [ ! -s $LASTFILE ]; then
		echo "NOLASTFILE"
	fi
fi

popd >/dev/null
