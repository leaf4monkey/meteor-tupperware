FROM                  registry.aliyuncs.com/becool_tech/meteor-tupperware:setup

COPY                  ./run/* /scripts/

COPY                  . /tmp

RUN                   chmod +x /tmp -R && \
                      chmod +x /scripts -R && \
                      chown -Rh nodejs:nodejs /home/nodejs/output && \
                      chown -R nodejs:nodejs /var/log

ONBUILD ENV           PORT=3000

ONBUILD ADD           package.json /home/nodejs/app/

ONBUILD RUN           cd /home/nodejs/app/ && npm install

ONBUILD COPY          ./ /home/nodejs/app

ONBUILD RUN           sh /tmp/build/pre_build.sh

ONBUILD USER          nodejs

ONBUILD RUN           sh /tmp/build/build.sh

ONBUILD USER          root

ONBUILD RUN           sh /tmp/build/post_build.sh

ONBUILD USER          nodejs

ONBUILD WORKDIR       /home/nodejs/output/bundle