# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  - 2.4.2

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## staging/production server set up
```bash
# check
bundle exec itamae ssh -h <host> -u root -p <port_num> -j ./cookbooks/nodes/node.json -n ./cookbooks/recipe_stg.rb

# commit
bundle exec itamae ssh -h <host> -u root -p <port_num> -j ./cookbooks/nodes/node.json ./cookbooks/recipe_stg.rb
```

```bash
# initialize
bundle exec cap staging deploy:initial

# check
bundle exec cap staging deploy:check

# commit
bundle exec cap staging deploy
```
