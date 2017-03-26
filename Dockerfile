FROM                  node:4.8.1-slim

ADD                   /etc/timezone /etc/timezone

RUN                   cp /usr/share/zoneinfo/$(cat /etc/timezone | awk 'NR==1') /etc/localtime

COPY                  ./run/* /scripts/

COPY                  . /tmp

RUN                   mkdir /home/node/output && mkdir /home/node/app && \
                      chown -R node:node /var/log && \
                      chmod +x /tmp -R && chmod +x /scripts -R

ENTRYPOINT            /scripts/startup.sh

ONBUILD COPY          ./ /home/node/app

ONBUILD ENV           METEOR_RELEASE=1.4.3.2 METEOR_ALLOW_SUPERUSER=true

ONBUILD RUN           apt-get update && apt-get install build-essential g++ python make -y --no-install-recommends&& \
                      sh /tmp/build/npm_deps_install.sh && \
                      . /tmp/build/pre_build.sh && \
                      curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh && \
                      sh /tmp/build/build.sh && \
                      . /tmp/build/post_build.sh && \
                      sh /tmp/build/post_build_clean.sh

ONBUILD USER          $APP_RUNNING_USER

ONBUILD WORKDIR       /home/node/output/bundle
