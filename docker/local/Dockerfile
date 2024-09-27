# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Download Common Packages
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
  build-essential \
  default-libmysqlclient-dev \
  gnupg2 \
  curl \
  vim \
  git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log


# Configure bundler
ENV \
  LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_APP_CONFIG=.bundle

# Abbreviate binstub settings
ENV PATH /app/bin:$PATH

# Install bundler
RUN \
  gem update --system && \
  gem install bundler

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app
