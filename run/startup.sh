#!/bin/sh

sh ./pre_build_env_setup.sh

sh ./post_build_env_setup.sh

exec node /home/node/output/bundle/main.js "$@"