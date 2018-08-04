#!/bin/bash
TEMPFILE=".bot.spell.temp"
pushd `dirname $0` >/dev/null
echo $@ | aspell -a > $TEMPFILE
perl getspell.pl $@
popd >/dev/null
