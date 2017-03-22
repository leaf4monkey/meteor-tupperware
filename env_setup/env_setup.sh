#!/bin/sh
groupadd -r nodejs && useradd -m -r -g nodejs nodejs

mkdir /home/nodejs/output
mkdir /home/nodejs/app
chmod +x /tmp -R

# install dumb-init
#wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
#chmod +x /usr/local/bin/dumb-init