
nuke:
	@docker-compose down --rmi all --volumes --remove-orphans

start:
	@docker-compose up -d

stop:
	@docker-compose stop

setup:
	@docker-compose build

enter-neos:
	@docker-compose exec neos /bin/bash

enter-db:
	@docker-compose exec maria-db /bin/bash

enter-assets:
	@docker-compose exec neos-assets /bin/bash

logs:
	@docker-compose logs -f

open:
	@open http://127.0.0.1:8081


enter-production-neos:
	@echo 'TODO'

open-production-db:
	@echo 'TODO'

