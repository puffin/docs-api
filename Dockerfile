FROM node:9.2

ENV APP_NAME=apidoc
ENV APP_USER=apidoc
ENV USER_HOME=/home/$APP_USER
ENV APP_HOME=$USER_HOME/$APP_NAME

COPY package.json $APP_HOME/
COPY config.ini $APP_HOME/
COPY index.js $APP_HOME/
COPY Makefile $APP_HOME/
COPY v1 $APP_HOME/v1

WORKDIR $APP_HOME
RUN npm install --production

RUN export v=$(awk -F "=" '/version/ {print $2}' config.ini) && sed -ri "s/^(\s*)(version\s*:\s*1.0.0\s*$)/\1version: $v/" v1/source/introduction.yaml

# Build docs
RUN make build

CMD ["node", "index.js"]
