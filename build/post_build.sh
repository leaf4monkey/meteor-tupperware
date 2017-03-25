#!/bin/sh

cd /home/node/output/bundle/programs/server
yarn install

chown -R node:node /home/node/output

node /tmp/hooks/post_build.js

sh /tmp/hooks/post_build_env_setup.sh