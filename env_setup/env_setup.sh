#!/bin/sh
METEOR_SYMLINK_TARGET="$(readlink "/home/nodejs/.meteor/meteor")"
METEOR_TOOL_DIRECTORY="$(dirname "$METEOR_SYMLINK_TARGET")"
LAUNCHER="/home/nodejs/.meteor/$METEOR_TOOL_DIRECTORY/scripts/admin/launch-meteor"

cp $LAUNCHER /usr/local/bin/meteor

mkdir /home/nodejs/output
mkdir /home/nodejs/app

chmod +x /scripts -R
chown -Rh nodejs:nodejs /home/nodejs/output
chown -R nodejs:nodejs /var/log