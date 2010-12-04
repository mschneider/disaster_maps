#!/bin/bash
#
# simple shell script to transform the content of src/ to a fully self contained target directory.
#
# TODO transform to some proper build system

HQCLIENT_BASEDIR=${HQCLIENT_BASEDIR=`dirname $0`}
PROJ_BASEDIR=${PROJ_BASEDIR=$HQCLIENT_BASEDIR/..}
POLYMAPS_BASEDIR=${POLYMAPS_BASEDIR=$PROJ_BASEDIR/../polymaps/}

TARGET=${TARGET=$HQCLIENT_BASEDIR/target}

if ! [ -d "$POLYMAPS_BASEDIR" ] ; then
 echo "please checkout polymaps next to disaster_map"
 exit
fi

mkdir -p $TARGET
mkdir -p $TARGET/js/lib

# 'deploy' html - this goes to toplevel, so must be done first
rsync -a --delete $HQCLIENT_BASEDIR/src/html/ $TARGET/

# 'deploy' js
rsync -a --delete $HQCLIENT_BASEDIR/src/js/ $TARGET/js/
[ -d $TARGET/js/lib/ ] || mkdir -p $TARGET/js/lib/
cp $POLYMAPS_BASEDIR/polymaps.js $TARGET/js/lib/

# 'deploy' css
[ -d $TARGET/css ] || mkdir -p  $TARGET/css
sass --update $HQCLIENT_BASEDIR/src/sass:$TARGET/css
