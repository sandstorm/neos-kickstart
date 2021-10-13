# MyVendor.AwesomeNeosProject Documentation

TODO: improve README

Table of contents:
- [requirements](#requirements)
- [local development setup](#local-development-setup)
- [running tests](#running-tests)
- [packages we recommend for certain use-cases](#packages-we-recommend-for-certain-use-cases)

## setting up IntelliJ
- recommended plugins:
  - Neos Support
  - Makefile language
  - PHP
  - PHP Annotations
  - PHP Toolbox
  - Prettier
  - Docker


## requirements
- docker for mac

## local development setup

- run `docker-compose build`
- run `docker-compose up -d`
- run `docker-compose logs -f`
- run `docker-compose stop`
- run `docker-compose down` (cleanup)
- run `composer install` in `/app` for autocompletion


## running tests
Docker environment for tests currently missing, run tests local (run `composer install` in `/app`)

```
./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Unit
./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Functional
```
