FROM node:16.11

RUN yarn config set cache-folder /app/.yarn-cache

WORKDIR /app

CMD cd src/Private && yarn install && yarn watch
