FROM          registry.aliyuncs.com/becool_tech/meteor-tupperware:setup

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           cd /home/nodejs/app/ && npm install

ONBUILD COPY          ./ /home/nodejs/app

ONBUILD RUN           ls /home/nodejs/app -a

ONBUILD RUN           sh /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           sh /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           sh /tmp/build/post_build.sh

ONBUILD USER          nodejs

ONBUILD WORKDIR       /home/nodejs/output/bundle