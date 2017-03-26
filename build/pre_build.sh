#!/bin/sh
if [ ! -d "/home/node/app/.meteor" ]; then
  echo "This doesn't look like a Meteor project. Meteor-builder is exiting..."
  exit 1
fi

if [ -z "$PORT" ]; then
  export PORT=3000
fi

node /tmp/hooks/pre_build.js

. /tmp/hooks/pre_build_env_setup.sh
