FROM                  node:4.6.2

RUN                   whoami

COPY                  . ~/scripts

RUN                   ~/scripts/env_setup/install_meteor.sh

RUN                   ~/scripts/env_setup/env_setup.sh

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           npm install

ONBUILD COPY          . /home/nodejs/app

ONBUILD RUN           ~/scripts/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           ~/scripts/build/build.sh

ONBUILD RUN           ~/scripts/build/post_build.sh

ENTRYPOINT            ~/scripts/run/startup.sh