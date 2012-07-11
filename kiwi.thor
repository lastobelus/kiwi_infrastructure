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
      run "git submodule foreach git checkout master"
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
  
  desc "bundler", "runs bundle install"
  def bundler
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
  
  desc "setup", "Sets up the kiwi deployment platform for development"
  def setup
    invoke 'kiwi:rvm'
    invoke 'kiwi:pkg'
    invoke 'kiwi:init_submodules'
    invoke 'kiwi:bundler'
  end
end