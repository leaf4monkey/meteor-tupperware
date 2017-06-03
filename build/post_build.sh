#!/bin/sh

cd /home/node/output/bundle/programs/server
npm install

chown -R node:node /home/node/output

node /tmp/hooks/post_build.js

. /tmp/hooks/post_build_env_setup.sh
