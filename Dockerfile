FROM --platform=linux/arm64 ruby:2.6.5-alpine

ARG UID=1026
ARG GID=100

COPY qemu-aarch64-static /usr/bin

RUN adduser -D -S snotes -g $GID -u $UID

RUN apk add --update --no-cache \
    alpine-sdk \
    mariadb-dev \
    tzdata

WORKDIR /syncing-server

RUN chown -R $UID:$GID .

USER snotes

COPY --chown=$UID:$GID Gemfile Gemfile.lock /syncing-server/

RUN gem install bundler && bundle install

COPY --chown=$UID:$GID . /syncing-server

ENTRYPOINT [ "docker/entrypoint.sh" ]

CMD [ "start-web" ]

