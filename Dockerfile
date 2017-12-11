FROM node:9.2

ENV APP_NAME=apidoc
ENV APP_USER=apidoc
ENV USER_HOME=/home/$APP_USER
ENV APP_HOME=$USER_HOME/$APP_NAME

COPY package.json $APP_HOME/
COPY index.js $APP_HOME/
COPY Makefile $APP_HOME/
COPY v1 $APP_HOME/v1

WORKDIR $APP_HOME
RUN npm install --production

# Build docs
RUN make build

CMD ["node", "index.js"]
