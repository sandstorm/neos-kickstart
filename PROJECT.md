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
- Vips (instead of ImageMagick)
- Supercronic
- Bash-Highlighting (dev, staging, production)
- Gitlab-CI Pipeline Config
  - Kubernetes Deployment
  - E2E Tests
  - Functional Tests
  - Unit Tests
- Testsetup
  - Functional and Unit
  - Behavioural Tests
    - Playwright Integration
  - Playwright Testrunner

## Setting up IntelliJ
- recommended plugins:
  - Neos Support
  - Makefile language
  - PHP
  - PHP Annotations
  - PHP Toolbox
  - Prettier
    - make sure Prettier is activated for the correct extensions
  - Docker
  - Behat Support
- check, if autocompletion works for .yaml-files
- check, if it's possible to jump to Fusion Prototypes via cmd + click


## Requirements
- docker for mac
- node -> to run Playwright Tests or for local development (without docker) of your sites JavaScript

## Local Development Setup (only required once)

This should only be needed when runing the project for the first time.

- run `composer install` in `/app` for autocompletion
- run `make setup` only the first time to setup folders and build
- run `cd ./e2e-testrunner && nvm use && npm install` as we do not want to use a docker container to be able
  to debug Playwright test more easily. TODO: maybe run in `make tests` but nvm is currently giving us a headache here.

## Local Development

- run `make start` to start all needed container of the project (see `docker-compose.yml` for details)
- run `make watch-assets` to see the logs of scss being compiled to css and ts being compiled to js
  - alternatively you can install node dependencies and run the watcher locally
  - `cd app/DistributionPackages/MyVendor.AwesomeNeosProject/Resources/Private/`
  - `yarn && yarn run watch`
  - see `package.json` for more scripts
- run `make help` to see all available commands

## running tests

- `make e2e-tests` to run behavioural tests
- `unit-tests` to run unit tests 
- `functional-tests` to run functional tests
