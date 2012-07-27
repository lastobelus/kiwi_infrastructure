
# Chef (Built-in)
## Chef Handlers

Exception and Report handlers are a feature of Chef that allow you to run code in response to a Chef run succeeding or failing. The most obvious use is to dispatch notifications if a Chef run fails, though it is also possible to gather rich data about your chef usage for trending and analysis.

* http://wiki.opscode.com/display/chef/Distributing+Chef+Handlers
* http://wiki.opscode.com/display/chef/Exception+and+Report+Handlers

# Testing #

## SimpleCuke ##

https://github.com/iafonov/simple_cuke




## Cuken ##

## Aruba ##
CLI Steps for Cucumber
### Reporting ###
set shell var:

    ARUBA_REPORT_DIR=doc cucumber features

### Step List ###

https://github.com/cucumber/aruba/blob/master/lib/aruba/cucumber.rb

## Chefspec ##

https://github.com/acrmp/chefspec

## minitest-chef-handler

https://github.com/calavera/minitest-chef-handler
https://github.com/btm/minitest-handler-cookbook


# Monitoring #

etsy's use of chef + graphite
http://www.slideshare.net/jonlives/michelin-starred-cooking-with-chef


# Knife-Spork #
ease multi-developer work on chef repo
https://github.com/jonlives/knife-spork