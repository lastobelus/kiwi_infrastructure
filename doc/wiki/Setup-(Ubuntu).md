# Ubuntu

We need to use ruby 1.9.3, and it is best to use rvm to manage the ruby version.

## Packages

    sudo apt-get install build-essential ruby git-core curl 

## install [rvm](http://www.andrehonsberg.com/article/install-rvm-ubuntu-1204-linux-for-ruby-193)
````
    bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> .bashrc
    source ~/.bashrc  
````

## use rvm to install ruby
````
    # Install ruby's dependencies
    sudo apt-get install build-essential openssl libreadline6 libreadline6-dev\
       zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev\
       libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

    # Finally you're ready to install ruby the RVM way!
    rvm install ruby-1.9.3-p194

    rvm use ruby-1.9.3
    rvm gemset create kiwi-integration
````

## set up SSH for git access
* check for existing keys, or create a new one
````
    ssh-keygen -t dsa
````
* give public key to Richard to get git access


## clone the repo

   git clone git@eable.sourcerepo.com:eable/kiwi_infrastructure.git
   cd kiwi_infrastructure

## .rvmrc file
make a .rvmrc to specify the gemset. rvm will switch to the specified ruby and gem set whenever it sees the .rvmrc (in this directory or any directory below it). It should contain:
````
      rvm ruby-1.9.3-p194@kiwi-integration
````
now cd out of the directory and back into it...
## install bundler
````
    gem install bundler
    gem install rake
````

## libgecode
install libgecode-dev the old fashioned way, and the latest version of libgecode (otherwise dep_selector will barf at you)
````
      curl http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
      sudo apt-get update
      sudo apt-get install libgecode-dev
    
      curl -C - -O  http://www.gecode.org/download/gecode-3.5.0.tar.gz
      tar zxvf gecode-3.5.0.tar.gz
      cd gecode-3.5.0 && ./configure
      make && make install
````

## Gems
use bundler fetch all the gems you will need for kiwi-infrastructure

      bundle install

## Run the setup task
````
    thor kiwi:setup
````
the kiwi:setup task will do several things, including checking out the submodules from which kiwi_infrastructure is composed, and will run bundle install again in kiwi-ironfan-homebase