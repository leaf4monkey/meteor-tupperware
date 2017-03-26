#!/bin/sh

cd /home/node/output/bundle/programs/server
yarn install

chown -R node:node /home/node/output

node /tmp/hooks/post_build.js
