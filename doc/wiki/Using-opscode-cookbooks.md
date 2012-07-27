Opscode publishes a number of cookbooks for common devops components, as well as providing hosting of cookbooks provided by the community. They can be browsed [here](http://community.opscode.com/cookbooks)

Since we are [[Using Berkshelf]] to manage cookbooks, to add a new cookbook from the Opscode community cookbooks, just add it to the Berksfile in the root of kiwi-ironfan-homebase

    cookbook "COOKBOOK_NAME"

and run

    berks install --shims

to add it to the cookbooks directory and

    knife cookbook upload COOKBOOK_NAME

to push it up to the Chef Server