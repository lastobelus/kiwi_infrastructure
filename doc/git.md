# Source Structure #

kiwi_infrastructure (git@github.com:lastobelus/kiwi_infrastructure.git)
|-- doc
|-- kiwi-ironfan-ci (submodule: git@github.com:lastobelus/kiwi-ironfan-ci.git)
|   |-- cookbooks
|   |   |-- apache2 (installed directly with knife)
|   |   |-- cassandra -> ../vendor/ironfan-pantry/cookbooks/cassandra (symlink to pantry)
|   |-- knife
|   |   |-- credentials -> local-credentials
|   |   |-- example-credentials
|   |   `-- local-credentials (submodule: git@eable.sourcerepo.com:eable/kiwi-credentials.git)
|-- kiwi-ironfan-homebase (submodule: git@github.com:lastobelus/kiwi-ironfan-homebase.git)
`-- php_helloworld_app (submodule)


# Merge upstream ironfan homebase #


git fetch upstream
git merge upstream/master
