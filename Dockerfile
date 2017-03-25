FROM                  node:4.8.1-slim

COPY                  ./run/* /scripts/

COPY                  . /tmp

RUN                   mkdir /home/node/output && mkdir /home/node/app && \
                      chown -R node:node /var/log && \
                      chmod +x /tmp -R && chmod +x /scripts -R && \
                      npm install -g yarn

ONBUILD COPY          ./ /home/node/app

ONBUILD ENV           PORT=3000 METEOR_RELEASE=1.4.3.2 METEOR_ALLOW_SUPERUSER=true

ONBUILD RUN           apt-get update && apt-get install build-essential g++ python -y --no-install-recommends&& \

                      sh /tmp/build/npm_deps_install.sh && \

                      curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh && \

                      sh /tmp/build/pre_build.sh && \

                      sh /tmp/build/build.sh && \

                      sh /tmp/build/post_build.sh

ONBUILD WORKDIR       /home/node/output/bundle
