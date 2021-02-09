FROM ruby:2.7-alpine

WORKDIR /app

RUN apk add --no-cache \
      git \
      build-base \
      imagemagick

COPY . .

RUN gem install bundler

RUN bundle install

RUN apk del -r --purge --no-cache \
      git \
      build-base
