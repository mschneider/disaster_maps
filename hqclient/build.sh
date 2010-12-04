#!/bin/bash
#
# simple shell script to transform the content of src/ to a fully self contained target directory.
#
# TODO transform to some proper build system

HQCLIENT_BASEDIR=${HQCLIENT_BASEDIR=`dirname $0`}
PROJ_BASEDIR=${PROJ_BASEDIR=$HQCLIENT_BASEDIR/..}
POLYMAPS_BASEDIR=${POLYMAPS_BASEDIR=$PROJ_BASEDIR/../polymaps/}
JQUERY_UI_BASEDIR=${JQUERY_UI_BASEDIR=$PROJ_BASEDIR/../jquery-ui-1.8.6.custom}
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

# include 3rdparty stuff
[ -d $TARGET/js/lib/ ] || mkdir -p $TARGET/js/lib/
cp $POLYMAPS_BASEDIR/polymaps.js $TARGET/js/lib/
cp $JQUERY_UI_BASEDIR/js/jquery-ui-1.8.6.custom.min.js $TARGET/js/lib/

# 'compile' css
compass compile --sass-dir src/sass/ --images-dir src/img/ --javascripts-dir src/js/ --css-dir target/css/

# 3rdparty css
rsync -a --delete $JQUERY_UI_BASEDIR/css/ui-lightness/ $TARGET/css/ui-lightness/
