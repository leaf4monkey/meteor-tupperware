FROM                  node:4.6.2

ENV                   PORT=80 METEOR_RELEASE="1.4.1"

RUN                   apt-get update && apt-get install build-essential g++ python -y

COPY                  . /tmp

RUN                   curl https://install.meteor.com -o /tmp/install_meteor.sh

RUN                   sed -i.bak -r 's/RELEASE=".*"/RELEASE=1.4.1/g' /tmp/install_meteor.sh

RUN                   chmod +x /tmp -R

RUN                   /tmp/install_meteor.sh

RUN                   groupadd -r nodejs && useradd -m -r -g nodejs nodejs

RUN                   mkdir /home/nodejs/output

RUN                   mkdir /home/nodejs/app

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           cd /home/nodejs/app/ && npm install

ONBUILD COPY          ./ /home/nodejs/app

ONBUILD RUN           ls /home/nodejs/app -l

ONBUILD RUN           /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           /tmp/build/build.sh

ONBUILD RUN           /tmp/build/post_build.sh

ENTRYPOINT            /tmp/run/startup.sh