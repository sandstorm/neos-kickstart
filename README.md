# Sandstorm Neos on Docker Kickstart

## !!!
Current project-name is "Sandstorm/ProjectX". Search and replace ProjectX with own project-name.
Also in the Sites.xml


## requirements
- docker for mac


## local dev setup

- run `composer install` in `/app` for autocompletion
- run `docker-compose build`
- run `docker-compose up -d`
- run `docker-compose logs -f`
- run `docker-compose stop`
- run `docker-compose down` (cleanup)

## running Tests
Docker environment for tests currently missing, run tests local (run `composer install` in `/app`)

```
./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/Sandstorm.ProjectX/Tests/Unit
./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/Sandstorm.ProjectX/Tests/Functional
```

## deployment

First you need to create a new namespace in the rancher ui, then create a new dns entry for your project.

You really need to make sure the namespace is configured the right way in `/deployment/production/database.yaml`
and `/deployment/production/deployment.yaml`.

Just push and it should work.

Site import and creating an user in production/staging is only possible via command line.
