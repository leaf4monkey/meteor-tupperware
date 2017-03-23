FROM                  node:4.6.2

ENV                   PORT=80 METEOR_RELEASE="1.4.1"

RUN                   apt-get update && apt-get install build-essential g++ python -y

COPY                  . /tmp

#RUN export METEOR_NO_RELEASE_CHECK=true
#RUN curl https://install.meteor.com/?release=1.4.1 | sh

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

ONBUILD RUN           ls /home/nodejs/app -a

ONBUILD RUN           /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           /tmp/build/post_build.sh

ONBUILD USER          nodejs

ENTRYPOINT            /tmp/run/startup.sh