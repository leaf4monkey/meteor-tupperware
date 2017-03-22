FROM                  node:4.6.2

RUN                   apt-get update && apt-get install build-essential g++ python -y

RUN                   curl https://install.meteor.com | sh

COPY                  . /scripts

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