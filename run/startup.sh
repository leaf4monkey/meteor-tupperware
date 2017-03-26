#!/bin/sh

sh /scripts/pre_build_env_setup.sh

sh /scripts/post_build_env_setup.sh

exec node /home/node/output/bundle/main.js "$@"