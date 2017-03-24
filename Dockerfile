FROM                  node:4.6.2-slim

COPY                  ./run/* /scripts/

COPY                  . /tmp

RUN                   mkdir /home/node/output && mkdir /home/node/app

ONBUILD ADD           package.json /home/node/app/

ONBUILD RUN           sh /tmp/build/npm_deps_install.sh

ONBUILD COPY          ./ /home/node/app

ONBUILD ENV           PORT=3000 METEOR_RELEASE=1.4.3.2 METEOR_ALLOW_SUPERUSER=true

ONBUILD RUN           apt-get update && apt-get install build-essential g++ python -y --no-install-recommends&& \
                      chown -R node:node /var/log && \
                      chmod +x /tmp -R && chmod +x /scripts -R && \

                      curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh && \

                      sh /tmp/build/pre_build.sh && \

                      sh /tmp/build/build.sh && \

                      sh /tmp/build/post_build.sh

ONBUILD USER          node

ONBUILD WORKDIR       /home/node/output/bundle
