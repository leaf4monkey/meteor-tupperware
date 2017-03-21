FROM          node:4.6.2

ENV           NODE_VERSION="4.6.2" PHANTOMJS_VERSION="2.1.1" IMAGEMAGICK_VERSION="8:6.8.9.9-5"

COPY          includes /tupperware

RUN           sh /tupperware/scripts/_env_setup.sh

RUN           sh /tupperware/scripts/bootstrap.sh

EXPOSE        80

# COPY        package.json .
ONBUILD COPY  ./ /home/nodejs/app
ONBUILD RUN   chown -R nodejs:nodejs /home/nodejs/app
ONBUILD USER  nodejs
ONBUILD WORKDIR /home/nodejs/app

ONBUILD RUN   sh /tupperware/scripts/on_build.sh

ENTRYPOINT    sh /tupperware/scripts/start_app.sh
