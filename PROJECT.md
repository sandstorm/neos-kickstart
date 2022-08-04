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
- Swiftmailer + Mailhog

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

This should only be needed when running the project for the first time.

- run `git lfs install` and `git lfs pull` to get large files like the content dump (you need to install git-lfs on your machine)
- run `make setup` only the first time to setup docker images and tmp folders
- run `make build-e2e-testrunner` as we do not want to use a docker container to be able
  to debug Playwright test more easily. TODO: maybe run in `make tests` but nvm is currently giving us a headache here.
- for font awesome pro support in local dev
    - open: `app/DistributionPackages/MyVendor.AwesomeNeosProject/Resources/Private/.npmrc.sample`
    - and do what the file tells you ;)

## Local Development

- run `make start` to start all needed container of the project (see `docker-compose.yml` for details)
- run `make logs` and `make log-flow-exceptions` to see what's going on in the containers
- run `make logs-assets` to see the logs of scss being compiled to css and ts being compiled to js
    - alternatively you can install node dependencies and run the watcher locally
    - `cd app/DistributionPackages/MyVendor.AwesomeNeosProject/Resources/Private/`
    - `nvm install && nvm use && yarn && yarn run watch`
    - see `package.json` for more scripts
- run `make help` to see all available commands
- you can login to the [neos backend](http://localhost:8081/neos) with the credentials `admin` and `password`

## Staging

TODO!

### Debugging Emails

Swiftmailer is installed and configured to use Mailhog (local SMTP server) in development mode. You can visit the
Mailhog Web-UI at [http://localhost:8025/](http://localhost:8025/).

## Running Tests

Make sure the application is up and running `make start`.
Make sure you build the testrunner with `make build-e2e-testrunner`

- for E2E Test
  - in a new console run `make start-e2e-testrunner` to start the e2e-testrunner
  - in a new console run `make e2e-tests` to run the actual tests
- for Unit Tests run `make unit-tests` 
- for Functional Tests run `make functional-tests` 

### debug failing tests

1. see screenshots in `./e2e-testrunner`
2. reports can be viewed by installing playwright once globally (`npm install -g playwright`) and run the traces via
```
npx playwright show-trace e2e-testrunner/report_YOUR_FAILING_STEP.zip
```

#### run single BDD feature files / scenarios

The `make e2e-tests` command runs **all tests** what is handy before you push your commits.
Often, in TDD it is more practical to run single feature files or scenarios. That has to be done via
command line, since the IntelliJ integration "play button" does not work for our docker setup (afaik).

How to run single feature files (see also README of Sandstorm.E2ETestTools):
```
docker compose exec neos bin/behat -c Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Behavior/behat.yml.dist -vvv Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Behavior/Features/Frontend/404-page.feature
```

#### Generating content (node) fixtures workflow:

1. set up your test content that you want to export in the Neos backend (using the default local dev port `8080`)
2. write new commands for exporting specific pages in `\MyVendor\AwesomeNeosProject\Command\StepGeneratorCommandController` to export only specific nodes for your fixtures
3. Run and copy to clipboard with:
```
docker compose exec -T neos ./flow stepgenerator:homepage | pbcopy
docker compose exec -T neos ./flow stepgenerator:notfoundpage | pbcopy
```
4. paste into your feature files and run tests

### setup tests in IntelliJ

for auto-completion and IDEA support of your BDD Tests do the following steps:

1. make sure, you installed "Behat Support" Plugin
