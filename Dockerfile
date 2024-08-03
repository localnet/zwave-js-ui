# https://github.com/docker/build-push-action/issues/1071
FROM alpine:3.18 AS base

RUN apk add nodejs npm
RUN npm install -g zwave-js-ui

RUN apk add build-base jq linux-headers python3-dev
RUN npm_config_build_from_source=true npm rebuild -g @serialport/bindings-cpp
RUN apk del build-base jq linux-headers python3-dev


FROM alpine:latest

RUN apk add nodejs npm

COPY --from=base /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s ../lib/node_modules/zwave-js-ui/server/bin/www.js /usr/local/bin/zwave-js-ui

ENV STORE_DIR=/var/local/zwave-js-ui
ENV ZWAVEJS_EXTERNAL_CONFIG=/usr/local/share/zwave-js
ENV ZWAVEJS_LOCK_DIRECTORY=/run/lock/zwave-js

EXPOSE 8091

CMD ["zwave-js-ui"]
