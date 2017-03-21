# if in alpine
# apk update &&   apk add ca-certificates wget &&   update-ca-certificates
# apk --no-cache add openssl

# install dumb-init
wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
chmod +x /usr/local/bin/dumb-init

# add user and group nodejs:nodejs
groupadd -r nodejs && useradd -m -r -g nodejs nodejs