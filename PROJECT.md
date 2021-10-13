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
- check, if autocompletion works for .yaml-files
- check, if it's possible to jump to Fusion Prototypes via cmd + click


## requirements
- docker for mac

## local development setup
- run `composer install` in `/app` for autocompletion
- run `make start` to start the project, this will also open the url in the browser
- run `make help` to see all available commands

## running tests
Docker environment for tests currently missing, run tests local (run `composer install` in `/app`)

```
./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Unit
./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Functional
```
