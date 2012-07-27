# Cookbooks #

## Berkshelf ##

Cookbooks are managed by berkshelf (http://berkshelf.com/ for more info).

Berkshelf was patched to use relative paths in the Berksfile.lock file, which allows:

    ironfan_pantry = "vendor/ironfan-pantry/cookbooks"
    cookbook  "cassandra",       path:  "#{ironfan_pantry}/cassandra"

to work.

To work on a fork of a cookbook:

* clone the cookbook to /some/path
* set the path of the cookbook to /some/path in the Berksfile
* berks install --shims
* work in /some/path
*avoid checking in the temporarily changed Berksfile (this is not ideal. Maybe switch to a Berksfile.sample and gitignore Berksfile)

# Update a Cookbook #

* make edits in local repository
* upload to chef server:

    knife cookbook upload my_cookbook