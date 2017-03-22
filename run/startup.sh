#!/bin/sh
cd /home/nodejs/output/bundle/programs/server && npm install
exec node /home/nodejs/output/bundle/main.js "$@"