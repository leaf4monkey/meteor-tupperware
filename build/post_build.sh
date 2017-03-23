#!/bin/sh

cd /home/nodejs/output/bundle/programs/server
npm install

chown -Rh nodejs:nodejs /home/nodejs/output

rm /usr/local/bin/meteor && rm -rf /home/nodejs/.meteor

# Purge build deps
apt-get purge -y build-essential g++ python
apt-get remove --purge -y build-essential g++ python

# Autoremove any junk
apt-get clean -y
apt-get autoclean -y
apt-get autoremove -y

# Remove apt lists
rm -rf /var/lib/apt/lists/*

# Locale cleanup
cp -R /usr/share/locale/en\@* /tmp/ && rm -rf /usr/share/locale/* && mv /tmp/en\@* /usr/share/locale/

# Clean out docs
rm -rf /usr/share/doc /usr/share/doc-base /usr/share/man /usr/share/locale /usr/share/zoneinfo /var/cache/debconf/*-old

# Clean out package management dirs
rm -rf /var/lib/cache /var/lib/log

# Clean out /tmp
rm -rf /tmp/*

# Clear npm cache
npm cache clear

