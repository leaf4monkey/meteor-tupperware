#!/bin/sh

. /scripts/pre_start.sh

exec node /home/node/output/bundle/main.js "$@"