FROM                  node:4.6.2

ENV                   PORT=80 METEOR_RELEASE="1.4.1"

RUN                   apt-get update && apt-get install build-essential g++ python -y

COPY                  . /scripts

RUN                   curl https://install.meteor.com -o /scripts/install_meteor.sh

RUN                   sed -i.bak -r 's/RELEASE=".*"/RELEASE=$METEOR_RELEASE/g' /tmp/install_meteor.sh

RUN                   /scripts/install_meteor.sh

RUN                   groupadd -r nodejs && useradd -m -r -g nodejs nodejs

RUN                   mkdir /home/nodejs/output

RUN                   mkdir /home/nodejs/app

RUN                   chmod +x /scripts -R

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           npm install

ONBUILD COPY          . /home/nodejs/app

ONBUILD RUN           /scripts/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           /scripts/build/build.sh

ONBUILD RUN           /scripts/build/post_build.sh

ENTRYPOINT            /scripts/run/startup.sh