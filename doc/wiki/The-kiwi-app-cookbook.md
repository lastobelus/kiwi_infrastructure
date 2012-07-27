The kiwi-app cookbook uses the application & php resources to checkout and configure the kiwi app. It lives in

    kiwi_infrastructure/kiwi-ironfan-homebase/vendor/kiwi-pantry/cookbooks

Rather than keep multiple dsn's on each environment, only the dsn for the environment being deployed is created, and the databases.yml file is also configured only for the environment being deployed.