#!/bin/bash

cd ..;
#mkdir code;
cd code;

#api code
composer create-project symfony/website-skeleton api;
cd api;
composer config repositories.osds-api vcs https://github.com/osdevsoft/api;
composer require osds/api:dev-master;

#backoffice code
cd ..;
composer create-project symfony/website-skeleton backoffice;
cd backoffice;
composer config repositories.osds-backoffice vcs https://github.com/osdevsoft/backoffice;
composer require osds/backoffice:dev-master;


#docker-compose build;
#docker-compose up -d;

#add ip to local hosts file

