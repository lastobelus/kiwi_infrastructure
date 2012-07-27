Cookbooks are managed by [berkshelf](http://berkshelf.com/).

Berkshelf was patched to use relative paths in the Berksfile.lock file, which allows:

    ironfan_pantry = "vendor/ironfan-pantry/cookbooks"
    cookbook  "cassandra",       path:  "#{ironfan_pantry}/cassandra"

to work. This is why we are using a fork of Berkshelf, as set in the Gemfile

To work on a fork of an opscode or ironfan cookbook:

* fork the cookbook on github
* clone your fork to /some/path
* set the path of the cookbook to /some/path in the Berksfile
* berks install --shims
* do work in /some/path
* avoid checking in the temporarily changed Berksfile (this is not ideal. Maybe switch to a Berksfile.sample and gitignore Berksfile)
* when it works, push it up to the github fork, and set the Berksfile to use the github fork for that cookbook, for example:
````
cookbook "application", git: "https://github.com/lastobelus/chef-application.git", branch: "kiwi" 
````
* when a cookbook has multiple changes that you would like to see integrated upstream, it is best to keep the master branch of your fork on the same revision as the upstream master, put each fix/feature in a topic branch and submit individually as pull requests, and have a kiwi branch in your fork into which you merge all the fix/feature branches. Set the Berksfile to install the kiwi branch of the fork

# Update a Cookbook #

* make edits in local repository
* upload to chef server:

    knife cookbook upload my_cookbook