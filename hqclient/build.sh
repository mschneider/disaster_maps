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

# 'compile' html - this goes to toplevel, so must be done first
rsync -a --delete $HQCLIENT_BASEDIR/src/html/ $TARGET/

# 'compile' js
rsync -a --delete $HQCLIENT_BASEDIR/src/js/ $TARGET/js/
[ -d $TARGET/js/lib/ ] || mkdir -p $TARGET/js/lib/
cp $POLYMAPS_BASEDIR/polymaps.js $TARGET/js/lib/

# 'compile' css
compass compile --sass-dir src/sass/ --images-dir src/img/ --javascripts-dir src/js/ --css-dir target/css/
