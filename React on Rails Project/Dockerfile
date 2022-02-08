FROM ruby:2.5.1

ARG APP_HOME=/app

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  libssl-dev \
  wget

# install nodejs
ARG NODE_VERSION='10.x'
ARG ESLINT_VERSION='5.1.0'
ARG BABEL_ESLINT_VERSION='8.2.6'
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
RUN gem install foreman

# install specific version of bundler
RUN gem install bundler --no-rdoc --no-ri -v 1.17.3

# add project directory
RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

# copy ruby gemset and version files to help mimic multi-tenant environments
COPY .ruby-gemset .ruby-version ./

# install ruby gems
COPY vendor ./vendor
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
