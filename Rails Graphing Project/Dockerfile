FROM ruby:2.4.0

ARG APP_HOME=/app

# RUN rm /etc/apt/sources.list  && \
#     echo "deb http://archive.debian.org/debian/ jessie main" | tee -a /etc/apt/sources.list && \
#     echo "deb-src http://archive.debian.org/debian/ jessie main" | tee -a /etc/apt/sources.list && \
#     echo "Acquire::Check-Valid-Until false;" | tee -a /etc/apt/apt.conf.d/10-nocheckvalid && \
#     echo 'Package: *\nPin: origin "archive.debian.org"\nPin-Priority: 500' | tee -a /etc/apt/preferences.d/10-archive-pin && \
#     apt-get update

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  libssl-dev \
  wget

# install nodejs
ARG NODE_VERSION='6.x'
ARG ESLINT_VERSION='4.19.1'
ARG BABEL_ESLINT_VERSION='8.2.3'
ARG ESLINT_PLUGIN_REACT_VERSION='7.10.0'
ARG SASS_LINT_VERSION='1.12.1'

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
RUN apt-get update && apt-get install -y nodejs

# install node linters globally
RUN npm install -g eslint@${ESLINT_VERSION} &&\
    npm install -g babel-eslint@${BABEL_ESLINT_VERSION} &&\
    npm install -g eslint-plugin-react@${ESLINT_PLUGIN_REACT_VERSION} &&\
    npm install -g sass-lint@${SASS_LINT_VERSION}

# install yarn
ARG YARN_VERSION='1.7.0-1'
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn=${YARN_VERSION}

# install foreman
# RUN gem install foreman

# add project directory
RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

# cache common ruby gems
# COPY docker_cache/Gemfile docker_cache/Gemfile.lock ./
# RUN bundle install

# cache common node packages
# COPY docker_cache/package.json docker_cache/yarn.lock ./
# RUN yarn

# install ruby gems
# COPY vendor ./vendor
COPY Gemfile Gemfile.lock ./
RUN bundle install

# install node packages
COPY package.json yarn.lock ./
RUN yarn

# copy all project files
COPY . ./

# add credentials on build
ARG GITHUB_TOKEN
RUN git config --global url."https://$GITHUB_TOKEN:@github.cerrner.com/".insteadOf "https://github.cerrner.com/"
RUN rake Tide:VaultApi:setup:env -- -cconfig/vault_credentials.yml -oconfig/env/tide/credentials.env
