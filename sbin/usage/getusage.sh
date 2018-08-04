#!/bin/bash
pushd `dirname $0` >/dev/null
perl getusage.pl $@
popd >/dev/null
