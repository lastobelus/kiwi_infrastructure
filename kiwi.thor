class Kiwi < Thor
  include Thor::Actions
  BREW_PACKAGES = %w{gecode}
  SUBMODULES_WITH_SUBMODULES = %w{kiwi-ironfan-homebase kiwi-ironfan-ci}
  SUBMODULES_WITH_GEMFILES        = %w{kiwi-ironfan-homebase kiwi-ironfan-ci}
  no_tasks do
    def found!(what)
      @@found ||= []
      @@found << what
    end

    def user
      @user = %x["whoami"].chomp
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
      if run("which #{name}", :verbose => false) ||
          (name != 'brew'&& check_presence('brew') && run('brew list', :capture => true, :verbose => false).include?(name))
        say "Found #{name}", :green
        found!(name)
        true
      else
        false
      end
    end
    
    def init_git_submodules(dir)
      say "Loading git submodules for #{dir}"
      
      run "git submodule update --init"
    end
    
  end
  
  desc 'brew', 'Installs homebrew package manager'
  def brew
    unless check_presence('brew')
      say "Installing homebrew for #{user}", :green
      run " /usr/bin/ruby -e \"$(curl -fsSL https://raw.github.com/gist/323731)\""
    end
  end

  desc "pkg", "install dependencies. currently only supports brew on os x"
  def pkg
    invoke "kiwi:brew"
    BREW_PACKAGES.each do |pkg|
      run "brew install #{pkg}" unless check_presence(pkg)
    end
  end
  
  desc "rvm", "Installs RVM"
  def rvm
    unless check_presence('rvm')
      say "Installing rvm for #{user}", :green
      run "bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)"
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
    in_root do
      init_git_submodules(`pwd`)
    end
    SUBMODULES_WITH_SUBMODULES.each do |dir|
      inside dir do
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
    invoke 'kiwi:rvm'
    invoke 'kiwi:pkg'
    invoke 'kiwi:init_submodules'
    invoke 'kiwi:submodules_heads'
    invoke 'kiwi:bundler'
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