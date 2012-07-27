Several open-source tools are used together to manage the infrastructure buildout.
## [Chef](http://www.opscode.com/products/)
Chef is an open-source systems integration framework built specifically for automating the cloud. It uses ruby as a language, but has a dsl that makes many common devops tasks easy.
## Hosted Chef
Hosted chef is a chef server that is free for up to 5 nodes. Since ironfan deletes nodes when killing a cluster, this provides a convenient way for testing clusters
## Kiwi Chef Server
(to be built) A Chef Server deployed to the VPC, for managing Kiwi's Infrastructure
## [Ironfan](https://github.com/infochimps-labs/ironfan)
Ironfan is a "Chef Orchestration Layer" It allows you to define inter-related clusters of machines in a single file, and spin them up in the cloud, update them as a group, or kill them with single commands.
## [Berkshelf](http://berkshelf.com/) 
Berkshelf provides a tool for managing the chef cookbooks used to define the kiwi infrastructure, which come from several sources.