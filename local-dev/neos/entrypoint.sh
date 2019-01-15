#!/bin/sh

composer install

./flow doctrine:migrate
./flow site:import --package-key Sandstorm.ProjectX
./flow user:create --roles Administrator admin password LocalDev Admin
./flow resource:publish

./flow server:run --host=0.0.0.0
