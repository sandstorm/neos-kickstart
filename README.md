# Sandstorm Neos on Docker Kickstart

This packages helps you to quickly set up a Neos Project. Besides a basic Neos setup
we provided examples and configuration that helps us to quickly provide a kickstart.

## requirements

- docker for mac

## Running Kickstart

Run `./kickstart.sh` an follow the instructions.

## Packages we recommend for certain use-cases

1. `sitegeist/monocle` for prototyping components
2. `yoast/yoast-seo-for-neos` for a real good SEO experience
3. `flowpack/nodetemplates` adds possibility to auto-generate content to newly created nodes -> helps with the editor experience
4. `neos/form-builder` + `neos/form` + `neos/form-fusionrenderer` to let editors build forms or to create powerful static form node-types
5. `flowpack/listable` to get pagination for lists of node-types (blog posts for example)

## Development

As the script can be used to change the git remote and remove files development becomes hard ;)
Run `./kickstart.sh --dev` to not remove certain files e.g. `./kickstart.sh`. 
Run `./kickstart.sh --restore-git` after testing changes you made to `./kickstart.sh`


## Roadmap

### Prio 1

* Das Ding von Sebastian einbauen
* Monocle ausbauen
* Bilder
  * Bildvarianten Beispiel -> src-set, picture, fusion context
  * Vips Bildoptimierung anschauen -> Beispielkonfig tunen -> https://gitlab.sandstorm.de/sebastian/revoband/-/tree/master/app/DistributionPackages/Sandstorm.DynamicImage

### Backlog

* Neues Distribution Package -> Beispiele für Rechte in Neos    
* Custom Backend Module Beispiel in extra Distribution Package
* Frontendlogin in extra Distribution Package
* DataPrivacy -> maybe change config of Neos
* check caching config -> nginx e.g. images
* Distribution Package with search
* Check examples for accessibility issues
