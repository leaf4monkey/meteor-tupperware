FROM                  node:4.6.2-slim

COPY                  ./run/* /scripts/

COPY                  . /tmp

ENV                   PORT=3000 METEOR_RELEASE=1.4.3.2 METEOR_NO_RELEASE_CHECK=true

RUN                   apt-get update && apt-get install build-essential g++ python -y && \
                      chown -R node:node /var/log && \
                      chmod +x /tmp -R && chmod +x /scripts -R

USER                  node

RUN                   curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh && \
                      sh /tmp/env_setup/env_setup.sh

ONBUILD ADD           package.json /home/node/app/

ONBUILD RUN           sh /tmp/build/npm_deps_install.sh

ONBUILD COPY          ./ /home/node/app

ONBUILD RUN           ls /home/node/ -l

ONBUILD RUN           sh /tmp/build/pre_build.sh && sh /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           sh /tmp/build/post_build.sh

ONBUILD USER          node

ONBUILD WORKDIR       /home/node/output/bundle
