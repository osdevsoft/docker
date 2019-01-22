#!/bin/bash

cd ..;
composer create-project symfony/website-skeleton api;

cd api;
composer config repositories.osds-api vcs https://github.com/osdevsoft/api;
composer require osds/api:dev-master;

cd ..;
composer create-project symfony/website-skeleton backoffice;
composer config repositories.osds-backoffice vcs https://github.com/osdevsoft/backoffice;
composer require osds/backoffice:dev-master;


#docker-compose build;
#docker-compose up -d;

#add ip to local hosts file

