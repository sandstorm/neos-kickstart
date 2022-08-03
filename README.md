# Sandstorm Neos on Docker Kickstart

This packages helps you to quickly set up a Neos Project. Besides a basic Neos setup
we provided examples and configuration that helps us to quickly provide a kickstart.

## requirements

- docker for mac
  - enable VirtioFS in docker host settings (experimental features)
  - alternatively, comment out the volume mount in the docker-compose.yml if you encounter bad local performance 
- node -> to run Playwright Tests or for local development (without docker) of your sites JavaScript

## Features
- Neos 7.3
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

## Running Kickstart when cloning this repo

!!!If you want to clone this package for another project:!!!
Run `./kickstart.sh` an follow the instructions.

## Local Development Setup (only required once)

This should only be needed when running the project for the first time.

- run `git lfs install` and `git lfs pull` to get large files like the content dump
- run `make setup` only the first time to setup docker images and tmp folders
- run `make setup-idea` on your local machine for autocompletion in your IDE
- run `cd ./e2e-testrunner && nvm install && nvm use && npm install` as we do not want to use a docker container to be able
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

## Packages we recommend for certain use-cases

1. `sitegeist/monocle` for prototyping components
2. `yoast/yoast-seo-for-neos` for a real good SEO experience
3. `flowpack/nodetemplates` adds possibility to auto-generate content to newly created nodes -> helps with the editor experience
4. `neos/form-builder` + `neos/form` + `neos/form-fusionrenderer` to let editors build forms or to create powerful static form node-types
5. `flowpack/searchplugin` to implement a search
6. or have a look at the recommandations on neos.io: https://www.neos.io/features/feature-list.html

## Development

As the script can be used to change the git remote and remove files development becomes hard ;)
Run `./kickstart.sh --dev` to not remove certain files e.g. `./kickstart.sh`. 
Run `./kickstart.sh --restore-git` after testing changes you made to `./kickstart.sh`
Run `make logs` and `make log-flow-exceptions` to see what's going on in the containers

## IMPORT/EXPORT Content

The default flow command to import and export the site content is not stable.
So we developed an easy-to-use shell script for this case and made it part of the make file:

### EXPORT
The script places two archives in `app/ContentDump` for DB Content and the Ressources.
(Maybe init git lfs for the repo if you plan to use this script)

```bash
make site-export
```

### IMPORT

```bash
make site-import
```

You have to re-create the local admin user again after the import is finished.

`./flow user:create --roles Administrator admin password LocalDev Admin || true`

## Roadmap
Things we want to add or document for an easier kickstart.

* image variants and responsive images (src-set, ...)
* improve image optimization with Vips -> see https://gitlab.sandstorm.de/sebastian/revoband/-/tree/master/app/DistributionPackages/Sandstorm.DynamicImage

### Backlog

* Examples for rights in Neos -> separate Distribution Package
* Custom Backend Module Beispiel in extra Distribution Package
* Frontendlogin in extra Distribution Package
* DataPrivacy -> maybe change config of Neos
* check caching config -> nginx e.g. images
* Distribution Package with search
* Check examples for accessibility issues
