# Sandstorm Neos on Docker Kickstart

This packages helps you to quickly set up a Neos Project. Besides a basic Neos setup
we provided examples and configuration that helps us to quickly provide a kickstart.

## requirements

- docker for mac
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

## Running Kickstart

Run `./kickstart.sh` an follow the instructions.

## Start project

```bash
make setup
make start
```

## Packages we recommend for certain use-cases

1. `sitegeist/monocle` for prototyping components
2. `yoast/yoast-seo-for-neos` for a real good SEO experience
3. `flowpack/nodetemplates` adds possibility to auto-generate content to newly created nodes -> helps with the editor experience
4. `neos/form-builder` + `neos/form` + `neos/form-fusionrenderer` to let editors build forms or to create powerful static form node-types
5. `flowpack/listable` to get pagination for lists of node-types (blog posts for example)
6. `flowpack/searchplugin` to implement a search
7. or have a look at the recommandations on neos.io: https://www.neos.io/features/feature-list.html

## Development

As the script can be used to change the git remote and remove files development becomes hard ;)
Run `./kickstart.sh --dev` to not remove certain files e.g. `./kickstart.sh`. 
Run `./kickstart.sh --restore-git` after testing changes you made to `./kickstart.sh`
Run `make logs` and `make log-flow-exceptions` to see what's going on in the containers

## IMPORT/EXPORT Content

The default flow command to import and export the site content is not stable.
So we (Flo) developed an easy-to-use shell script for this case and made it part of the make file:

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
