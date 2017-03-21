#!/bin/sh

BASEDIR=`dirname $0`

. $BASEDIR/_common.sh

if [ $DO_PRE_CLEAN -eq 'true' ]; then
  . $BASEDIR/_pre_clean.sh
fi

. $BASEDIR/_install_deps.sh

# . $BASEDIR/_install_node.sh

. $BASEDIR/_setup_tupperbuild.sh

. $BASEDIR/_post_clean.sh
