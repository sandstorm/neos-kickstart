help:
	@cat Makefile
nuke:
	@docker compose down --rmi all --volumes --remove-orphans

setup:
	@mkdir -p ./tmp/composer_cache
	@mkdir -p ./tmp/.yarn-cache
	@make build

start:
	@docker compose up -d

build:
	@docker compose build

stop:
	@docker compose stop

enter-neos:
	@docker compose exec neos /bin/bash

enter-db:
	@docker compose exec maria-db /bin/bash

enter-assets:
	@docker compose exec neos-assets /bin/bash

watch-assets:
	@docker compose logs -f neos-assets

logs:
	@docker compose logs -f

ps:
	@docker compose ps

open-site:
	@open http://127.0.0.1:8081

open-neos:
	@open http://127.0.0.1:8081/neos

open-site-e2e:
	@open http://127.0.0.1:9090

open-local-db:
	@open "mysql://neos:neos@localhost:13306/neos"
	@open "mysql://neos:neos@localhost:13306/neos_e2etest"

open-styleguide:
	@open http://127.0.0.1:8081/styleguide

e2e-tests:
	@docker compose exec maria-db "/createTestingDB.sh"
	@docker compose exec neos bash -c "FLOW_CONTEXT=Development/Docker/Behat ./flow doctrine:migrate"
	@docker compose exec neos bin/behat -c Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Behavior/behat.yml.dist -vvv
	@echo
	@echo "   The STYLEGUIDE can ACTUALLY be found at http://127.0.0.1:9090/styleguide/"
	@echo

unit-tests:
	@docker compose exec neos bash -c "./bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Unit"

functional-tests:
	@docker compose exec neos bash -c "./bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml Packages/Sites/MyVendor.AwesomeNeosProject/Tests/Functional"

