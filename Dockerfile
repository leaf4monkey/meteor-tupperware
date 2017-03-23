FROM                  debian:jessie

FROM                  node:4.6.2-slim

ENV                   PORT=80 METEOR_RELEASE=1.4.1 METEOR_NO_RELEASE_CHECK=true

RUN                   apt-get update && apt-get install build-essential g++ python -y

RUN                   groupadd -r nodejs && useradd -m -r -g nodejs nodejs

COPY                  . /tmp

USER                  nodejs

RUN                   curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

USER                  root

RUN                   cp /home/nodejs/.meteor/packages/meteor-tool/${METEOR_RELEASE}/mt-os.linux.x86_64/scripts/admin/launch-meteor /usr/local/bin/meteor

RUN                   chmod +x /tmp -R

RUN                   mkdir /home/nodejs/output

RUN                   mkdir /home/nodejs/app

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           cd /home/nodejs/app/ && npm install

ONBUILD COPY          ./ /home/nodejs/app

ONBUILD RUN           ls /home/nodejs/app -a

ONBUILD RUN           /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           /tmp/build/post_build.sh

ONBUILD USER          nodejs

ENTRYPOINT            /tmp/run/startup.sh