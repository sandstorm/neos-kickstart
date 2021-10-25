# MyVendor.AwesomeNeosProject Documentation

TODO: improve README

Table of contents:
- [requirements](#requirements)
- [local development setup](#local-development-setup)
- [running tests](#running-tests)
- [packages we recommend for certain use-cases](#packages-we-recommend-for-certain-use-cases)

## Features
- Neos 7.2
- PHP 8.0
- MariaDB 10.3
- Vips (instead of imagic)
- Supercronic
  - TODO: small crontab example + link to supercronic docs
- Bash-Highlighting (dev, staging, production)

## Setting up IntelliJ
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


## Requirements
- docker for mac

## Local Development Setup

This should only be needed when runing the project for the first time.

- run `composer install` in `/app` for autocompletion
- run `make setup` only the first time to setup folders and build

## Local Development

- run `make start` to start all needed container of the project (see `docker-compose.yml` for details)
- run `make watch-assets` to see the logs of scss being compiled to css and ts being compiled to js
  - alternatively you can install node dependencies and run the watcher locally
  - `cd app/DistributionPackages/MyVendor.AwesomeNeosProject/Resources/Private/`
  - `yarn && yarn run watch`
  - see `package.json` for more scripts
- run `make help` to see all available commands

## running tests
Docker environment for tests currently missing, run tests local (run `composer install` in `/app`)

```
./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Unit
./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Functional
```
