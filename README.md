# Sandstorm Neos on Docker Kickstart

Table of contents:
- [requirements](#requirements)
- [rename the project after copying this folder!](#rename-the-project-after-copying-this-folder-)
- [local development setup](#local-development-setup)
- [running tests](#running-tests)
- [packages we recommend for certain use-cases](#packages-we-recommend-for-certain-use-cases)

## requirements
- docker for mac


## rename the project after copying this folder!
Current project-name is "Sandstorm/ProjectX". Search and replace ProjectX with own project-name, by running the script lines below:

```
# Adjust to your desired package name and composer package name here

export NEOS_PACKAGE_NAME="Company.Site"
export COMPOSER_PACKAGE_NAME="company\/site"

cd app
# rename site package folder
mv DistributionPackages/Sandstorm.ProjectX DistributionPackages/${NEOS_PACKAGE_NAME}

# rename Flow Package Key
find ./DistributionPackages/${NEOS_PACKAGE_NAME} -type f -not -path "*/node_modules/*" -exec grep -Iq . {} \; -print | xargs sed -i '' "s/Sandstorm\.ProjectX/${NEOS_PACKAGE_NAME}/g"

# rename PHP classes
find ./DistributionPackages/${NEOS_PACKAGE_NAME} -type f -not -path "*/node_modules/*" -exec grep -Iq . {} \; -print | xargs sed -i '' "s/Sandstorm\\\\ProjectX/${NEOS_PACKAGE_NAME//./\\\\}/g"

# rename PHP classes in composer.json files
find ./DistributionPackages/${NEOS_PACKAGE_NAME} -type f -not -path "*/node_modules/*" -exec grep -Iq . {} \; -print | xargs sed -i '' "s/Sandstorm\\\\\\\\ProjectX/${NEOS_PACKAGE_NAME//./\\\\\\\\}/g"

# rename composer key
find ./DistributionPackages/${NEOS_PACKAGE_NAME} -type f -not -path "*/node_modules/*" -exec grep -Iq . {} \; -print | xargs sed -i '' "s/sandstorm\/ProjectX/${COMPOSER_PACKAGE_NAME}/g"
find ./composer.json -type f -not -path "*/node_modules/*" -exec grep -Iq . {} \; -print | xargs sed -i '' "s/sandstorm\/ProjectX/${COMPOSER_PACKAGE_NAME}/g"

# update composer.lock
composer update

# update Gitlab-CI and docker-compose.yml
cd ..
find .gitlab-ci.yml docker-compose.yml | xargs sed -i '' "s/Sandstorm\.ProjectX/${NEOS_PACKAGE_NAME}/g"
find .gitlab-ci.yml | xargs sed -i '' "s/sandstorm\.projectx__composer/${NEOS_PACKAGE_NAME}__composer/g"
```

**Finally, do a case insensitive search for "ProjectX"; you should be only left with a few places in Sites.xml, the deployment manifests, and the README. Adjust these places manually!**

NOTE: The find is quite sophisticated:
- skips node-modules (`-not -path "*/node_modules/*"`) [Explanation here](https://stackoverflow.com/a/15736463/4921449)
- skips binary files (`-exec grep -Iq . {} \; -print`) [Explanation here](https://stackoverflow.com/a/13659891/4921449)


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
./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/Sandstorm.ProjectX/Tests/Unit
./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/Sandstorm.ProjectX/Tests/Functional
```

## packages we recommend for certain use-cases

1. `sitegeist/monocle` for prototyping components
2. `yoast/yoast-seo-for-neos` for a real good SEO experience 
3. `flowpack/nodetemplates` adds possibility to auto-generate content to newly created nodes -> helps with the editor experience
4. `neos/form-builder` + `neos/form` + `neos/form-fusionrenderer` to let editors build forms or to create powerful static form node-types
5. `flowpack/listable` to get pagination for lists of node-types (blog posts for example)
