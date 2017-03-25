#!/bin/sh
if [ ! -d "/home/node/app/.meteor" ]; then
  echo "This doesn't look like a Meteor project. Meteor-builder is exiting..."
  exit 1
fi

if [ -z "$PORT" ]; then
  export PORT=3000
fi

node /tmp/hooks/pre_build.js
sh /tmp/hooks/pre_build_env_setup.sh

echo "current meteor settings:"
echo METEOR_SETTINGS=$METEOR_SETTINGS

if [ -z "$METEOR_SETTINGS" ]; then
  export 'METEOR_SETTINGS=$DFT_METEOR_SETTINGS'
fi

echo "check default meteor settings:"
echo DFT_METEOR_SETTINGS=$DFT_METEOR_SETTINGS