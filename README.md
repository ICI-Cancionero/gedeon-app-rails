# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 3.2.1

* System dependencies:
  - Docker (Compose v2)

* Configuration
  ```bash
  docker compose build
  ```

* Database creation
  ```bash
  docker compose run --rm web bundle exec rails db:create
  ```


* Database initialization
    ```bash
  docker compose run --rm web bundle exec rails db:migrate
  docker compose run --rm web bundle exec rails db:seed
  ```

* Running on local
    ```bash
  docker compose up
  ```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
  ```git push origin master```

## Notes

* Postgres version: 17 (via Docker image `postgres:17`).
* If you need a clean local database (destructive):
  ```bash
  docker compose down
  docker volume rm -f gedeon-app-rails_postgres-data
  docker compose up -d
  docker compose run --rm web bundle exec rails db:prepare
  docker compose run --rm web bundle exec rails db:seed
  ```
