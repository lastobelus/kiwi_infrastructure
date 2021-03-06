require 'berkshelf/thor'

class Kiwi < Thor
  include Thor::Actions
  BREW_PACKAGES = %w{gecode}
  APT_PACKAGES = %w{libgecode-dev}
  SUBMODULES_WITH_SUBMODULES = %w{kiwi-ironfan-homebase kiwi-ironfan-ci}
  SUBMODULES_WITH_GEMFILES = %w{kiwi-ironfan-homebase kiwi-ironfan-ci}

  no_tasks do
    def found!(what)
      @@found ||= []
      @@found << what
    end

    def user
      @user = %x["whoami"].chomp
    end

    def operating_system
      @os ||= RbConfig::CONFIG['host_os']
    end

    def user_home
      Thor::Util.user_home
    end

    def found?(what)
      @@found ||= []
      @@found.include?(what)
    end

    def check_presence name
      return true if found?(name)

      present = false

      if run("which #{name}", :verbose => false)
        present = true
      else

          case operating_system
            when "linux-gnu"
              if check_presence("dpkg")
                if run("dpkg --listfiles #{name} | grep #{name}", :verbose => false)
                    say "in here"
                    present = true
                    found!(name)
                end
              end

            when /^darwin/
              if (name != 'brew' && check_presence('brew') && run('brew list', :capture => true, :verbose => false).include?(name))
                present = true
                found!(name)
              end
            else

          end
      end

      if present
        say "found #{name}", :green
        found!(name)
      end

      present
    end

    def init_git_submodules(dir)
      say "in init_git_submodules #{dir}"

      tries = 0;
      while(tries < 3 && !run("git submodule update --init")) do
        tries += 1;
        say "attempt number #{tries} has failed..."
      end
    end

  end

    desc 'which', 'performs which'
    def which
        check_presence("garbage")
        check_presence("ruby")
        check_presence("libgecode-dev")
    end

  desc 'brew', 'Installs homebrew package manager'
  def brew
    unless check_presence('brew')
      say "Installing homebrew for #{user}", :green
      run " /usr/bin/ruby -e \"$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)\""
    end
  end

  desc "pkg", "install dependencies. currently only supports brew on os x"
  def pkg

    case operating_system
        when "linux-gnu"

            APT_PACKAGES.each do |pkg|
                if !check_presence(pkg)
                    run "sudo apt-get install #{pkg}"
                else
                    say "#{pkg} is already installed"
                end
            end

        when "darwin"
            say "iDetected: OS X"

            invoke "kiwi:brew"
            BREW_PACKAGES.each do |pkg|
              run "brew install #{pkg}" unless check_presence(pkg)
            end
        else
            say "WARNING: futuristic space operating system detected..."
            say "  failed to install some packages"

            APT_PACKAGES.each do |pkg|
                say "  failed to install #{pkg}"
            end

            BREW_PACKAGES.each do |pkg|
                say "  failed to install #{pkg}"
            end
    end
  end

  desc "rvm", "Installs RVM"
  def rvm
    unless check_presence('rvm')
      say "Installing rvm for #{user}", :green
      run "curl -L https://get.rvm.io | bash -s stable --ruby"
    end
  end
  
  
  desc "rvmrc", "creates a rvmrc with kiwi gemset"
  method_options :name => :default
  def rvmrc
    raise Thor::Error.new("haven't figured out how to make this work yet; please run\nrvm --rvmrc --create 1.9.3@kiwi-ironfan\nmanually in an interactive shell")
    invoke 'kiwi:rvm'
    run %Q{bash -l "rvm --rvmrc --create 1.9.3@kiwi-ironfan"}
  end
  
  desc "bundler", "runs bundle install"
  def bundler
    run "bundle install"
    SUBMODULES_WITH_GEMFILES.each do |dir|
      inside dir do
        run "bundle install"
      end
    end
  end
  
  desc "init_submodules", "initializes git submodules"
  def init_submodules
    say "in init_submodules:"
    in_root do
      say "  in root do"
      init_git_submodules(`pwd`)
    end
    SUBMODULES_WITH_SUBMODULES.each do |dir|
      say "  in SUBMODULES_WITH_SUBMODULES.each do"
      inside dir do
        say "    in dir do"
        init_git_submodules(dir)
      end
    end
  end
  
  desc "submodules_heads", "puts each git submodule on master & pulls"
  def submodules_heads
    in_root do
      run "git submodule foreach git checkout master"
      run "git submodule foreach git pull"    
    end
    SUBMODULES_WITH_SUBMODULES.each do |dir|
      inside dir do
        run "git submodule foreach git checkout master"
        run "git submodule foreach git pull"    
      end
    end
  end

  desc "setup", "Sets up the kiwi deployment platform for development"
  def setup
    say "in setup"
    invoke 'kiwi:rvm'
    invoke 'kiwi:pkg'
    invoke 'kiwi:init_submodules'
    invoke 'kiwi:submodules_heads'
    invoke 'kiwi:bundler'
    invoke 'kiwi:berksfile'
    invoke 'kiwi:chef_conf'
  end
  
  desc "berksfile", "removes kiwi-ironfan-homebase/cookbooks and does berks install --shims"
  def berksfile
    homebase = "kiwi-ironfan-homebase/cookbooks"
    inside "kiwi-ironfan-homebase" do
      run "rm -rf cookbooks"
      berksfile = File.join(Dir.pwd, Berkshelf::DEFAULT_FILENAME)
      invoke 'berkshelf:install', [], shims: "cookbooks", berksfile: berksfile
    end
  end
  
  
  desc "pull", "pulls kiwi_infrastructure, runs git submodule update, and bundle install"
  method_options :name => :default
  def pull
    run "git pull"
    run "git submodule update"
    invoke 'kiwi:bundler'
  end
  
  desc "chef_conf", "links .chef to kiwi-ironfan-homebase"
  def chef_conf
    raise Thor::Error.new('kiwi-ironfan-homebase must be installed. Run thor kiwi:setup first') unless File.exist?('kiwi-ironfan-homebase')
    unless File.exist?('.chef')      
      run "ln -s kiwi-ironfan-homebase/knife .chef"
    else
      say ".chef already exists!", :red
    end
  end
  
end
