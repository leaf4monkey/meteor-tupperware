FROM          registry.aliyuncs.com/becool_tech/meteor-tupperware:setup

ADD           package.json /home/nodejs/app/

RUN           cd /home/nodejs/app/ && npm install

COPY          ./ /home/nodejs/app

RUN           ls /home/nodejs/app -a

RUN           /tmp/build/pre_build.sh

USER          nodejs

RUN           /tmp/build/build.sh

USER          root

RUN           /tmp/build/post_build.sh

USER          nodejs

WORKDIR       /home/nodejs/output/bundle