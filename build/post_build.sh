#!/bin/sh

cd /home/node/output/bundle/programs/server
yarn install

chown -R node:node /home/node/output

node /tmp/hooks/post_build.js

if [ -z "$METEOR_SETTINGS" ]; then
  export METEOR_SETTINGS=$DFT_METEOR_SETTINGS
fi

echo DFT_METEOR_SETTINGS=$DFT_METEOR_SETTINGS

echo METEOR_SETTINGS=$METEOR_SETTINGS