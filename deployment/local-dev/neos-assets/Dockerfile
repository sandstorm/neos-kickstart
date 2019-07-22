FROM node:10.11

RUN yarn config set cache-folder /app/.yarn-cache

WORKDIR /app

CMD cd src/Private && yarn install && yarn watch:dev
