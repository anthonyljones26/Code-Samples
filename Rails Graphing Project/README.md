# results-graphing-fhir
Results Graphing SMART on FHIR app

***

## Local Development Quickstart
* On host machine:
  * Checkout VM branch:

          $ git clone -b VM --single-branch https://github.cerrner.com/till/results-graphing-fhir.git vm

  * Follow installation notes in VM branch's README
* On guest machine:
  * Go to your working directory, install gems, and start the server:

          $ cd /results-graphing/
          $ bundle install
          $ npm install
            - you may need to start vagrant with administrator privileges, so symlinks can be used during install
            - if you have errors during install, try to install or rebuild individual packages; for example:
              $ npm install webpack
              $ npm install webpack-dev-server
              $ npm rebuild node-sass
          $ npm start
            - you may need to adjust the start script in package.json to match your host "forwarded_port"
  * Generate Github Personal Access Token
  1. Navigate to Github > Settings > Developer Settings > [Personal access tokens](https://github.cerrner.com/settings/tokens)
  2. Click __Generate new token__
  3. Enter token description
  4. Select repo scope
      - [x] __repo__
  5. Click __Generate Token__
  6. Copy token into Host env var named GITHUB_TOKEN
      * *Once navigated away from generated token, token will be lost unless saved.*

  * Try it out in your browser:

          http://localhost:3000
            - where 3000 matches a host "forwarded_port" for the rails server in your Vagrantfile
  
## Editor Configuration
A **.editorconfig** file has been included in the root of the project to help define and maintain consistent coding styles between different editors and IDEs. See [EditorConfig](http://editorconfig.org/) for info about the file and how to use it in your editor or IDE.

## Linting
To see a list of all available lint options:

    rake -D lint
    
To run all linters:

    rake lint

## Unit and Feature Tests
To run rspec:

    rspec
    
To use guard to watch for file changes and run rspec:
  * By polling for file changes, when using vagrant box cannot see file changes:

        guard -p -l 10
          
  * By installing a vagrant plugin to forward file changes:
    1. Update Vagrantfile and append "fsnotify: true" to synced_folder that you want to watch. Example:

            config.vm.synced_folder "../results-graphing-fhir", "/results-graphing", fsnotify: true
          
    2. On host machine, install plugin and apply Vagrantfile changes:
    
      NOTE: To install the plugin, I had to update vagrant to a recent version (currently 1.9.2)
    
          vagrant plugin install vagrant-fsnotify
          vagrant provision

    3. On host machine, after vagrant box is started with "vagrant up":

            vagrant fsnotify
          
    4. On guest machine:
    
            guard
  
## To build assets (on guest machine)

    npm run build
