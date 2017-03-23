FROM                  registry.aliyuncs.com/becool_tech/meteor-tupperware:setup

COPY                  . /tmp

RUN                   chmod +x /tmp -R

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           cd /home/nodejs/app/ && npm install

ONBUILD COPY          ./ /home/nodejs/app

ONBUILD RUN           ls /tmp/build -la

ONBUILD RUN           sh /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           sh /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           sh /tmp/build/post_build.sh

ONBUILD USER          nodejs

ONBUILD WORKDIR       /home/nodejs/output/bundle