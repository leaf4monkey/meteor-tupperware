FROM                  node:4.6.2-slim

COPY                  ./run/* /scripts/

COPY                  . /tmp

ENV                   PORT=3000 METEOR_RELEASE=1.4.3.2 METEOR_NO_RELEASE_CHECK=true

RUN                   apt-get update && apt-get install build-essential g++ python -y && \
                      groupadd -r nodejs && useradd -m -r -g nodejs nodejs

USER                  nodejs

RUN                   curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

USER                  root

RUN                   chmod +x /tmp -R && /tmp/env_setup/env_setup.sh

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           sh /tmp/build/npm_deps_install.sh

ONBUILD COPY          ./ /home/nodejs/app

ONBUILD RUN           sh /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           sh /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           sh /tmp/build/post_build.sh

ONBUILD USER          nodejs

ONBUILD WORKDIR       /home/nodejs/output/bundle