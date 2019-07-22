# requirements 
- docker for mac


# local dev setup

- run `composer install` in `/app`
- run `docker-compose build`
- run `docker-compose up -d`
- run `docker-compose logs -f`
- run `docker-compose stop`
- run `docker-compose down` (cleanup)

# !!!
Current project-name is "Sandstorm/ProjectX". Search and replace ProjectX with own project-name.
Also in the Sites.xml


# running Tests
Docker environment for tests currently missing, run tests local (run `composer install` in `/app`)

```
./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/Sandstorm.ProjectX/Tests/Unit
./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/Sandstorm.ProjectX/Tests/Functional
```