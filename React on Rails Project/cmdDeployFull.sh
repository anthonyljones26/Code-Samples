#!/bin/bash
# Bash Menu for Common Commands

####
##
# Environment variables used by script:
#   - TIDE_DEPLOY_USERNAME: username on servers
#   - TIDE_DEPLOY_SERVER_CERT_A: certification server "A" IP
#   - TIDE_DEPLOY_SERVER_CERT_B: certification server "B" IP
#   - TIDE_DEPLOY_SERVER_PROD_A: production server "A" IP
#   - TIDE_DEPLOY_SERVER_PROD_B: production server "B" IP
#   - GITHUB_TOKEN: personal github token
##
####

function set_config {
  PRETEND=false

  # app specific (customize per app and release)
  # LOCAL_APP_DIR=PATH_TO_LOCAL_APP # example: /c/build/Portal/portal-results_entry_bp/develop
  # GIT_REPO_NAME=GIT_REPO_NAME_HERE # example: portal-results_entry_bp
  # GIT_BRANCH=GIT_BRANCH_HERE # example: release/1.3.0
  # RELEASE_DIR=RELEASE_DIRECTORY_HERE # example: release_1.x

  ####

  # Scorecard
  # LOCAL_APP_DIR=/c/build/Portal/portal-health_scorecard/portal-health_scorecard
  # GIT_REPO_NAME=portal-health_scorecard
  # GIT_BRANCH=release/3.1.0
  # RELEASE_DIR=release_3.x

  # Allergy Vials
  LOCAL_APP_DIR=/c/docker-apps/portal-allergy_vials
  GIT_REPO_NAME=portal-allergy_vials
  GIT_BRANCH=release/3.1.0
  RELEASE_DIR=release_3.x

  # BP Entry
  # LOCAL_APP_DIR=/c/build/Portal/portal-results_entry_bp/portal-results_entry_bp
  # GIT_REPO_NAME=portal-results_entry_bp
  # GIT_BRANCH=release/2.1.0
  # RELEASE_DIR=release_2.x

  # Future Orders
  #LOCAL_APP_DIR=/c/build/Portal/portal-future_orders/portal-future_orders
  #GIT_REPO_NAME=portal-future_orders
  #GIT_BRANCH=main
  #RELEASE_DIR=release_1.x

  ####

  # setup info
  ASSETS_DATE=`date +"%Y%m%d"`
  # ASSETS_DATE="20201117"
  ASSETS_INDEX="01"
  ASSETS_ARCHIVE="public_${SCRIPT_ENV}_${RELEASE_DIR}_${ASSETS_DATE}_${ASSETS_INDEX}.tar.gz"
  SERVER_BASE_DIR=/var/www
  # GIT_PROJECT="https://github.cerrner.com/till/${GIT_REPO_NAME}.git"
  GIT_PROJECT="https://${SCRIPT_USERNAME}@github.cerrner.com/till/${GIT_REPO_NAME}.git"

  # server info
  if [[ $SCRIPT_SERVER_A != "" ]] ; then
    SERVER_A=$SCRIPT_SERVER_A
  elif [[ $SCRIPT_ENV == "production" ]] ; then
    SERVER_A=$TIDE_DEPLOY_SERVER_PROD_A
  else
    SERVER_A=$TIDE_DEPLOY_SERVER_CERT_A
  fi
  if [[ $SCRIPT_SERVER_B != "" ]] ; then
    SERVER_B=$SCRIPT_SERVER_B
  elif [[ $SCRIPT_ENV == "production" ]] ; then
    SERVER_B=$TIDE_DEPLOY_SERVER_PROD_B
  else
    SERVER_B=$TIDE_DEPLOY_SERVER_CERT_B
  fi

  # dependency versions
  BUNDLER_VER=1.17.3
  RUBY_VER=2.5.1

  # combined helpers
  SERVER_APP_DIR="${SERVER_BASE_DIR}/${GIT_REPO_NAME}"
  SERVER_APP_RELEASE_DIR="${SERVER_APP_DIR}/${RELEASE_DIR}"
}

function show_config {
  cat << EOF
Config:
  PRETEND:                $PRETEND

  -- params
  SCRIPT_NAME:            $SCRIPT_NAME
  SCRIPT_ACTION:          $SCRIPT_ACTION
  SCRIPT_ENV:             $SCRIPT_ENV
  SCRIPT_SERVER:          $SCRIPT_SERVER
  SCRIPT_USERNAME:        $SCRIPT_USERNAME

  -- app info
  GIT_PROJECT:            $GIT_PROJECT
  GIT_BRANCH:             $GIT_BRANCH
  RELEASE_DIR:            $RELEASE_DIR
  ASSETS_ARCHIVE:         $ASSETS_ARCHIVE
  SERVER_APP_RELEASE_DIR: $SERVER_APP_RELEASE_DIR
  LOCAL_APP_DIR:          $LOCAL_APP_DIR

  -- server info
  SERVER_A:               $SERVER_A
  SERVER_B:               $SERVER_B

  -- dependency versions
  BUNDLER_VER:            $BUNDLER_VER
  RUBY_VER:               $RUBY_VER
EOF
}

function handle_main {
  [[ $SCRIPT_ACTION =~ ^(local|launch_docker|docker|launch_server|server)$ ]] || { show_help && return $SUCCESS; }
  [[ $SCRIPT_ACTION != "launch_server" || $SCRIPT_SERVER != "" ]] || { show_help && return $SUCCESS; }
  [[ $SCRIPT_ENV =~ ^(certification|production)$ ]] || { show_help && return $SUCCESS; }

  set_config

  case $SCRIPT_ACTION in
    local)
      handle_local
      ;;
    launch_docker)
      handle_launch_docker
      ;;
    docker)
      handle_docker
      ;;
    launch_server)
      handle_launch_server
      ;;
    server)
      handle_server
      ;;
  esac

  return $SUCCESS
}

function handle_local {
  PRETEND=false

  show_config
  # confirm "Continue with given config?" || return $SUCCESS

  local_options
  return $SUCCESS
}

function local_options {
  echo ""
  while true
  do
    local_options_menu || {
      [[ $? == $EXIT ]] && break || error "An error has occured."
    }
    echo ""
  done

  return $SUCCESS
}

function local_options_menu {
  local MENU_OPTIONS=(
    "Launch All"
    "Launch Docker"
    "Launch Server A"
    "Launch Server B"
    " - Exit - "
  )

  local PS3="Select option: "

  local dockerCmd="${SCRIPT_NAME} -a launch_docker -e ${SCRIPT_ENV} -u ${SCRIPT_USERNAME} --server-a ${SERVER_A} --server-b ${SERVER_B}"
  local serverACmd="${SCRIPT_NAME} -a launch_server -e ${SCRIPT_ENV} -u ${SCRIPT_USERNAME} -s ${SERVER_A}"
  local serverBCmd="${SCRIPT_NAME} -a launch_server -e ${SCRIPT_ENV} -u ${SCRIPT_USERNAME} -s ${SERVER_B}"
  local envLabel="[CERT]"
  if [[ $SCRIPT_ENV == "production" ]] ; then
    envLabel="[PROD]"
  fi

  select opt in "${MENU_OPTIONS[@]}"
  do
    if `contains_element "$opt" "${MENU_OPTIONS[@]}"`; then
      case $opt in
        "Launch All")
          log "LAUNCH: ${serverACmd}"
          bash -l -i -new_console:is1TVt:"serverA ${envLabel}" -c "${serverACmd}"
          log "LAUNCH: ${serverBCmd}"
          bash -l -i -new_console:is2THt:"serverB ${envLabel}" -c "${serverBCmd}"
          log "LAUNCH: ${dockerCmd}"
          bash -l -i -new_console:is1THt:"docker ${envLabel}" -c "${dockerCmd}"
          ;;
        "Launch Docker")
          log "LAUNCH: ${dockerCmd}"
          bash -l -i -new_console:it:"docker ${envLabel}" -c "${dockerCmd}"
          ;;
        "Launch Server A")
          log "LAUNCH: ${serverACmd}"
          bash -l -i -new_console:it:"serverA ${envLabel}" -c "${serverACmd}"
          ;;
        "Launch Server B")
          log "LAUNCH: ${serverBCmd}"
          bash -l -i -new_console:it:"serverB ${envLabel}" -c "${serverBCmd}"
          ;;
        " - Exit - ")
          return $EXIT
          ;;
      esac
      break
    else
      echo "invalid option"
    fi
  done

  return $SUCCESS
}

function is_docker_toolbox {
  if [ "${DOCKER_TOOLBOX_INSTALL_PATH}" ]; then
    return $SUCCESS
  fi

  return $FAILURE
}

function setup_docker_machine {
  if ! is_docker_toolbox ; then
    return $SUCCESS
  fi

  if docker-machine status default | grep '^Running$' &> /dev/null ; then
    eval $(docker-machine env default)
  else
    info "Starting docker machine..."
    docker-machine start
    eval $(docker-machine env default)
  fi
}

function handle_launch_docker {
  PRETEND=false

  setup_docker_machine

  exe "cd ${LOCAL_APP_DIR}"
  exe "docker-compose run -e GITHUB_TOKEN --rm --no-deps app bash -c \"\$(<${SCRIPT_NAME})\" -- -a docker -e ${SCRIPT_ENV} -u ${SCRIPT_USERNAME} --server-a ${SERVER_A} --server-b ${SERVER_B}"
}

function handle_docker {
  show_config
  # confirm "Continue with given config?" || return $SUCCESS

  docker_options
  return $SUCCESS
}

function valid_docker_environment {
  return $SUCCESS
}

function docker_options {
  valid_docker_environment || return $FAILURE

  echo ""
  while true
  do
    docker_options_menu || {
      [[ $? == $EXIT ]] && break || error "An error has occured."
    }
    echo ""
  done

  return $SUCCESS
}

function docker_options_menu {
  local MENU_OPTIONS=(
    "Retrieve vault credentials"
    "Copy vault credentials"
    "Build assets"
    "Copy assets"
    "Copy production.env"
    "bash -l -i"
    " - Exit - "
  )

  local PS3="Select option: "

  select opt in "${MENU_OPTIONS[@]}"
  do
    if `contains_element "${opt}" "${MENU_OPTIONS[@]}"`; then
      case $opt in
        "Build assets")
          confirm_or_exit_only "Manually setup app configs (RAILS_RELATIVE_URL_ROOT). Continue to next step?" && {
            info "Continuing..."
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }
          exe "rm -rf public/assets/ public/packs/" || return $FAILURE
          exe "NODE_ENV=${SCRIPT_ENV} RAILS_ENV=${SCRIPT_ENV} bundle exec rails assets:precompile" || return $FAILURE
          if [ -d "public/packs/" ]; then
            if [ -d "public/assets/" ]; then
              exe "tar -czvf public/${ASSETS_ARCHIVE} -C public/ assets/ packs/" || return $FAILURE
            else
              exe "tar -czvf public/${ASSETS_ARCHIVE} -C public/ packs/" || return $FAILURE
            fi
          else
            exe "tar -czvf public/${ASSETS_ARCHIVE} -C public/ assets/" || return $FAILURE
          fi
          ;;
        "Copy assets")
          exe "scp public/${ASSETS_ARCHIVE} ${SCRIPT_USERNAME}@${SERVER_A}:${SERVER_APP_RELEASE_DIR}/public/" || return $FAILURE
          exe "scp public/${ASSETS_ARCHIVE} ${SCRIPT_USERNAME}@${SERVER_B}:${SERVER_APP_RELEASE_DIR}/public/" || return $FAILURE
          ;;
        "Retrieve vault credentials")
          if [ -f "config/vault_credentials.yml" ]; then
            if [ $GITHUB_TOKEN ] ; then
              log "\$ git config --global url.\"https://\${GITHUB_TOKEN}:@github.cerrner.com/\".insteadOf \"https://github.cerrner.com/\""
              git config --global url."https://${GITHUB_TOKEN}:@github.cerrner.com/".insteadOf "https://github.cerrner.com/" || return $FAILURE
            fi

            if confirm "Retrieve for all environments?" ; then
              exe "rake Tide:VaultApi:setup:env -- -cconfig/vault_credentials.yml -o.deploy/development.env -edevelopment" || return $FAILURE
              exe "rake Tide:VaultApi:setup:env -- -cconfig/vault_credentials.yml -o.deploy/test.env -etest" || return $FAILURE
              exe "rake Tide:VaultApi:setup:env -- -cconfig/vault_credentials.yml -o.deploy/certification.env -ecertification" || return $FAILURE
              exe "rake Tide:VaultApi:setup:env -- -cconfig/vault_credentials.yml -o.deploy/production.env -eproduction" || return $FAILURE
            else
              exe "rake Tide:VaultApi:setup:env -- -cconfig/vault_credentials.yml -o.deploy/${SCRIPT_ENV}.env -e${SCRIPT_ENV}" || return $FAILURE
            fi
          else 
            echo ""
            info "Skipping vault, missing config file."
          fi
          ;;
        "Copy vault credentials")
          exe "scp .deploy/${SCRIPT_ENV}.env ${SCRIPT_USERNAME}@${SERVER_A}:${SERVER_APP_RELEASE_DIR}/config/env/tide/credentials.env" || return $FAILURE
          exe "scp .deploy/${SCRIPT_ENV}.env ${SCRIPT_USERNAME}@${SERVER_B}:${SERVER_APP_RELEASE_DIR}/config/env/tide/credentials.env" || return $FAILURE
          ;;
        "Copy production.env")
          exe "scp config/env/production.env ${SCRIPT_USERNAME}@${SERVER_A}:${SERVER_APP_RELEASE_DIR}/config/env/" || return $FAILURE
          exe "scp config/env/production.env ${SCRIPT_USERNAME}@${SERVER_B}:${SERVER_APP_RELEASE_DIR}/config/env/" || return $FAILURE
          ;;
        " - Exit - ")
          return $EXIT
          ;;
        *)
          exe $opt || return $FAILURE
          ;;
      esac
      break
    else
      echo "invalid option"
    fi
  done
}

function handle_launch_server {
  PRETEND=false

  # how to: see https://unix.stackexchange.com/questions/100652/bash-interactive-remote-prompt
  log "\$ ssh -t ${SCRIPT_USERNAME}@${SCRIPT_SERVER} ..."
  # ssh -t ${SCRIPT_USERNAME}@${SCRIPT_SERVER} bash -l -i "<(echo "$(cat ${SCRIPT_NAME} | base64 | tr -d '\n')" | base64 --decode)" -a server -e ${SCRIPT_ENV} -u ${SCRIPT_USERNAME}
  ssh -t ${SCRIPT_USERNAME}@${SCRIPT_SERVER} bash -l -i $'<(cat<<_ | base64 --decode\n'$(cat ${SCRIPT_NAME} | base64 | tr -d "\n")$'\n_\n)' -a server -e ${SCRIPT_ENV} -u ${SCRIPT_USERNAME}
}

function handle_server {
  show_config
  # confirm "Continue with given config?" || return $SUCCESS

  server_options
  return $SUCCESS
}

function valid_server_environment {
  if [ "$PRETEND" != true ] ; then
    if ! [ -d "${SERVER_APP_DIR}/" ] ; then
      if confirm "Directory "${SERVER_APP_DIR}/" does not exist. Would you like to create it?" ; then
        exe "mkdir -p ${SERVER_APP_DIR}/" || return $FAILURE
        exe "sudo chgrp -R support ${SERVER_APP_DIR}" || return $FAILURE
        exe "sudo chmod -R g+wx ${SERVER_APP_DIR}" || return $FAILURE
      else
        error "Directory "${SERVER_APP_DIR}/" does not exist. Exiting..."
        return $FAILURE
      fi
    fi

    if ! [ -x "$(command -v git)" ]; then
      error "git is not installed."
      return $FAILURE
    fi

    # NOTE: this is not working consistently on all servers
    # if ! [ -x "$(command -v rvm)" ]; then
    #   error "rvm is not installed\n"
    #   return $FAILURE
    # fi
  fi

  return $SUCCESS
}

function server_options {
  valid_server_environment || return $FAILURE

  echo ""
  while true
  do
    server_options_menu || {
      [[ $? == $EXIT ]] && break || error "An error has occured."
    }
    echo ""
  done

  return $SUCCESS
}

function server_options_menu {
  local MENU_OPTIONS=(
    "Setup project"
    "Setup assets"
    "git describe --tags"
    "rvm ls"
    "passenger-config about ruby-command"
    "sudo vi /etc/nginx/nginx.conf"
    "sudo service nginx restart"
    "tail -f log/certification.log"
    "tail -f log/production.log"
    "sudo tail -f /var/log/nginx/error.log"
    "df -h"
    "df -i"
    "bash -l -i"
    " - Exit - "
  )

  local PS3="Select option: "

  select opt in "${MENU_OPTIONS[@]}"
  do
    if `contains_element "$opt" "${MENU_OPTIONS[@]}"`; then
      case $opt in
        "Setup project")
          confirm "Setup project. Continue?" || return $SUCCESS

          if [ -d "${SERVER_APP_RELEASE_DIR}/" ]; then
            exe "cd ${SERVER_APP_RELEASE_DIR}/" || return $FAILURE
            exe "sudo chgrp -R support ${SERVER_APP_RELEASE_DIR}" || return $FAILURE
            exe "sudo chmod -R g+wx ${SERVER_APP_RELEASE_DIR}" || return $FAILURE
            exe "sudo chmod -R g+wx /usr/local/rvm/gems/ruby-${RUBY_VER}@${GIT_REPO_NAME}_${RELEASE_DIR}" || return $FAILURE
            exe "git remote set-url origin ${GIT_PROJECT}" || return $FAILURE
            exe "git stash" || return $FAILURE
            exe "git fetch" || return $FAILURE
            exe "git checkout ${GIT_BRANCH}" || return $FAILURE
            if git symbolic-ref -q HEAD ; then
              exe "git pull" || return $FAILURE
            fi
            exe "git stash pop" || return $FAILURE
          else
            exe "cd ${SERVER_APP_DIR}/" || return $FAILURE
            exe "sudo chmod -R g+wx ${SERVER_APP_DIR}" || return $FAILURE
            exe "git clone ${GIT_PROJECT} ${RELEASE_DIR}" || return $FAILURE
            exe "cd ${SERVER_APP_RELEASE_DIR}/" || return $FAILURE
            exe "git checkout ${GIT_BRANCH}" || return $FAILURE
            exe "echo '${GIT_REPO_NAME}_${RELEASE_DIR}' > .ruby-gemset" || return $FAILURE
          fi

          exe "cd ${SERVER_APP_RELEASE_DIR}/" || return $FAILURE

          if ! [ -d "config/env/tide/" ] ; then
            exe "mkdir -p config/env/tide/" || return $FAILURE
          fi

          confirm_or_exit_only "Manually setup configs, copy assets, and setup Nginx. Continue to next step?" && {
            info "Continuing..."
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }

          confirm_or_exit "Check Ruby version and Nginx passenger_ruby path. Continue?" && {
            exe "rvm ls" || return $FAILURE
            if exe "passenger-config about ruby-command" ; then
              confirm_or_exit_only "Continue to next step?" && {
                info "Continuing..."
              } || { [[ $? == $EXIT ]] && return $SUCCESS; }
            else
              exe "passenger-config about ruby-command" || {
                confirm_or_exit "Setup RVM wrapper (if 'Your RVM wrapper scripts are too old, or some wrapper scripts are missing' error). Continue?" && {
                  exe "rvmsudo rvm wrapper ruby-${RUBY_VER}@${GIT_REPO_NAME}_${RELEASE_DIR} --no-prefix --all" || return $FAILURE
                } || { [[ $? == $EXIT ]] && return $SUCCESS; }
              }
            fi
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }

          exe "gem install bundler --no-rdoc --no-ri -v ${BUNDLER_VER}" || return $FAILURE
          exe "bundle install --without development test" || return $FAILURE

          confirm_or_exit "Setup assets. Continue?" && {
            exe "rm -rf public/assets/ public/packs/" || return $FAILURE
            exe "tar -xzvf public/${ASSETS_ARCHIVE} -C public/" || return $FAILURE
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }

          confirm_or_exit "Restart Nginx. Continue?" && {
            exe "sudo nginx -t" || return $FAILURE
            exe "sudo service nginx restart" || return $FAILURE
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }
          ;;

        "Setup assets")
          exe "cd ${SERVER_APP_RELEASE_DIR}/" || return $FAILURE

          confirm_or_exit "Setup assets. Continue?" && {
            exe "rm -rf public/assets/ public/packs/" || return $FAILURE
            exe "tar -xzvf public/${ASSETS_ARCHIVE} -C public/" || return $FAILURE
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }

          confirm_or_exit "Restart Nginx. Continue?" && {
            exe "sudo nginx -t" || return $FAILURE
            exe "sudo service nginx restart" || return $FAILURE
          } || { [[ $? == $EXIT ]] && return $SUCCESS; }
          ;;

        "sudo service nginx restart")
          exe "sudo nginx -t" || return $FAILURE
          exe "sudo service nginx restart" || return $FAILURE
          ;;

        "bash -l -i")
          exe "cd ${SERVER_APP_RELEASE_DIR}/" || exe "cd ${SERVER_APP_DIR}/" || exe "cd ${SERVER_BASE_DIR}/" || return $FAILURE
          exe $opt || return $FAILURE
          ;;

        " - Exit - ")
          return $EXIT
          ;;

        *)
          exe "cd ${SERVER_APP_RELEASE_DIR}/" || return $FAILURE
          exe $opt || return $FAILURE
          ;;
      esac
      break
    else
      echo "invalid option"
    fi
  done

  return $SUCCESS
}

function confirm {
  echo ""
  while true; do
    printf "${GREEN}"
    read -p "${@} (y/n) " yn
    printf "${NC}"
    case $yn in
      y|Y ) return $SUCCESS;;
      n|N ) return $FAILURE;;
      * ) echo "invalid";;
    esac
  done
}

function confirm_or_exit {
  echo ""
  while true; do
    printf "${GREEN}"
    read -p "${@} (y/n/x) " ynx
    printf "${NC}"
    case $ynx in
      y|Y ) return $SUCCESS;;
      n|N ) return $FAILURE;;
      x|X ) return $EXIT;;
      * ) echo "invalid";;
    esac
  done
}

function confirm_or_exit_only {
  echo ""
  while true; do
    printf "${GREEN}"
    read -p "${@} (y/x) " yx
    printf "${NC}"
    case $yx in
      y|Y ) return $SUCCESS;;
      x|X ) return $EXIT;;
      * ) echo "invalid";;
    esac
  done
}

function contains_element {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return $SUCCESS; done
  return $FAILURE
}

function log {
  printf "${@}\n" >&2
}

function info {
  log "${GREEN}${@}${NC}"
}

function error {
  log "${RED}Error: ${@}${NC}"
}

function exe {
  log "\$ $*"

  if [ "$PRETEND" != true ] ; then
    eval "$@"
  fi
}

function set_globals {
  GREEN=$( tput setaf 2 )
  RED=$( tput setaf 1 )
  NC=$( tput sgr0 )

  SUCCESS=0
  FAILURE=1
  EXIT=9
}

function show_help {
  cat << EOF  
Deploy CWx Applications

Usage: $SCRIPT_NAME -a <action> [-e certification] [-s 127.0.0.1] [-u USERNAME] [-h]

-h, -help,          --help                  Display help
-a, -action,        --action                Set action <local|launch_docker|docker|launch_server|server>
-e, -environment,   --environment           Set environment <certification|production>
-s, -server,        --server                Set server ip
                    --server-a              Set server A ip
                    --server-b              Set server B ip
-u, -username,      --username              Set username to be used on servers

EOF
}

########################################################################################################################
########################################################################################################################
########################################################################################################################

set_globals

SCRIPT_NAME=$BASH_SOURCE
SCRIPT_ACTION="local"
SCRIPT_ENV="certification"
SCRIPT_SERVER=""
SCRIPT_SERVER_A=""
SCRIPT_SERVER_B=""
SCRIPT_USERNAME=$TIDE_DEPLOY_USERNAME

options=$(getopt -l "help,action:,environment:,server:,server-a:,server-b:,username:" -o "ha:e:s:u:" -a -- "$@")
eval set -- "$options"

while true
do
  case $1 in
    -h|--help)
      show_help
      exit $SUCCESS
      ;;
    -a|--action)
      shift
      SCRIPT_ACTION=$1
      ;;
    -e|--environment)
      shift
      SCRIPT_ENV=$1
      ;;
    -s|--server)
      shift
      SCRIPT_SERVER=$1
      ;;
    --server-a)
      shift
      SCRIPT_SERVER_A=$1
      ;;
    --server-b)
      shift
      SCRIPT_SERVER_B=$1
      ;;
    -u|--username)
      shift
      SCRIPT_USERNAME=$1
      ;;
    --)
      shift
      break;;
  esac
  shift
done

handle_main
wait
