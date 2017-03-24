#!/bin/sh
METEOR_SYMLINK_TARGET="$(readlink "/home/node/.meteor/meteor")"
METEOR_TOOL_DIRECTORY="$(dirname "$METEOR_SYMLINK_TARGET")"
LAUNCHER="/home/node/.meteor/$METEOR_TOOL_DIRECTORY/scripts/admin/launch-meteor"

cp $LAUNCHER /home/node/meteor

mkdir /home/node/output
mkdir /home/node/app
