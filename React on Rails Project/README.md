# portal-allergy_vials
[![Build Status](https://jenkins.cerrner.com/tide/buildStatus/icon?job=till%2Fportal-allergy_vials%2Fmaster)](https://jenkins.cerrner.com/tide/job/till/job/portal-allergy_vials/job/master/)
[![Ruby](https://img.shields.io/badge/Ruby-2.5.1-brightgreen.svg)](https://www.ruby-lang.org/en/)
[![Rails](https://img.shields.io/badge/Rails-5.2-brightgreen.svg)](http://rubyonrails.org/)
[![Node](https://img.shields.io/badge/Node-10.x-brightgreen.svg)](https://nodejs.org/)
[![Node](https://img.shields.io/badge/React-16.x-brightgreen.svg)](https://reactjs.org/)
  
Portal Allergy vials for request to refill an allergy vial through the portal.  
  uCern Wiki: https://wiki.ucern.com/display/InnovATE/2016.2.00176+-+Allergy+Vials+Refill

***

## Local Development Quickstart
### Prerequisites
* Install Docker  
  * [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/)
    * If you do NOT need to use VirtualBox in conjuction with Docker you can use [Docker for Windows](https://www.docker.com/docker-windows) for potentially improved performance and integration with your host machine
  * See [Docker Toolbox Tips and Issues](#docker-toolbox-tips-and-issues) for setup tips and common installation issues
  * [Docker for Windows](https://www.docker.com/docker-windows) *requires HyperV*
    * If you need to use VirtualBox in conjuction with Docker you can use [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) to use Docker with VirtualBox
  * [Docker for Mac](https://www.docker.com/docker-mac)
* Generate Github Personal Access Token
  1. Navigate to Github > Settings > Developer Settings > [Personal access tokens](https://github.cerrner.com/settings/tokens)
  2. Click __Generate new token__
  3. Enter token description
  4. Select repo scope
      - [x] __repo__
  5. Click __Generate Token__
  6. Copy token into Host env var named GITHUB_TOKEN
      * *Once navigated away from generated token, token will be lost unless saved.*

### Startup
* Checkout project
  * Https clone  
    ```bash
    git clone https://github.cerrner.com/till/portal-allergy_vials.git
    ```

  * SSH clone  
    ```bash
    git clone git@github.cerrner.com:till/portal-allergy_vials.git
    ```

* Start docker machine
  *You may skip this section if you are using Docker for Windows and it is auto-starting the docker machine*
  1. Open your favorite Bash Terminal or Windows Powershell
  2. Start the docker machine
     ```bash
     docker-machine start default
     ```
  3. Setup environment variables  
     ```bash
     eval $(docker-machine env default)
     ```

* Start server
  1. Open your favorite Bash Terminal or Windows Powershell
  2. For Docker Toolbox, ensure your environment variables are set  
  $ `eval $(docker-machine env default)`
  2. Navigate to project (`$ cd path/to/project`)
  3. Run docker-compose  
   $ `docker-compose up`  
   *ENV var GITHUB_TOKEN is needed to pull in the correct secrets*

* Port forwarding

  1. Open VirtualBox Manager
  2. Select the 'default' machine and click settings
  3. Go to Network > Advanced > Port Forwarding
  4. Add four port forwarding rules, 3000 and 3035 for the app, 6379 for redis, and 8000 for the SAML login, all which map from Host to Guest
  5. Click 'OK'

* Update hosts file with tide url  
  - File location:  
    ```C:\Windows\System32\drivers\etc\hosts```  
  - Add:
    ```
    127.0.0.1       tide.test # main app
    127.0.0.1       tide-alt.test # alternative domain
    ```
  *For docker toolbox users add new port 8000 to be forwarded to port 8000*
* Try it out in your browser:
  * For Docker for Windows (or Docker for Mac)
    * http://tide.test:3000
  * For Docker Toolbox or if you cannot use tide.test
    * Find your machine's IP address
      $ `docker-machine ip`
      * The IP is typically 192.168.99.100
    * http://192.168.99.100:3000
  * If another application is running on port 3000, update the ports section in the docker-compose.yml and then go to your IP or tide.test with your new port number.

### Running the Test suite
1. Open your favorite Bash Terminal or Windows Powershell
2. Navigate to project (`$ cd path/to/project`)
3. Run docker-compose  
   You can run the test suite with logs from all containers by running  
   
   ```
   docker-compose -f docker-compose.test.yml up
   ```

   This can display alot of unnecessary output to the terminal from the selenium browsers. You can add test or capybara params to run that test. This will show only the output to the terminal for test or capybara

   ```
   docker-compose -f docker-compose.test.yml up test

   docker-compose -f docker-compose.test.yml up capybara
   ```

   If you are looking to run both unit tests and capybara selenium tests together you can run

   ```
   docker-compose -f docker-compose.test.yml up test capybara
   ```

   This will display both test and capybara output to the terminal

## Linting
To see a list of all available lint options: `rails -D lint`

To run all linters: `rails lint`

How to run linters:  
1. By running a docker container with a command:  
   ```bash
   docker-compose run --rm app rails lint
   # Or individually as follows 
   docker-compose run --rm app rails lint:rubocop
   docker-compose run --rm app rails lint:eslint
   docker-compose run --rm app rails lint:sass
   docker-compose run --rm app rails lint:slim

   ```
2. Or you can run bash in a docker container, then run the lint command:  
   ```bash
   docker-compose run --rm app bash
   # within Docker container
   rails lint
   ```
