# Helpful Heroku Commands

## Managing Your App

```bash
heroku open                                 # open your app in a browser tab
heroku ps                                   # see the status of your heroku servers
heroku logs                                 # view the logs
heroku addons:create heroku-postgresql:dev  # add a PostgreSQL development DB
heroku addons:create mongolab:sandbox       # add a MongoLab DB
heroku run rake db:migrate                  # run db migrations
heroku run rake db:seed                     # run seeds.rb file
heroku run:detached rake db:migrate         # run detached from Terminal
```

## Debugging

```bash
heroku ps             # list process status of heroku processes
heroku releases       # list releases deployed to heroku for current app
heroku logs           # display logs for an app
heroku logs -n 1500   # default is 100 lines, but you can get up to 1500
heroku login          # authenticate with heroku so that you can connect
heroku run bash       # connect to heroku host machine
```

## General Commands

```bash
heroku help                             # prints help
heroku list                             # list all of your heroku apps
heroku info                             # prints info about the heroku project
heroku config                           # prints heroku environment variables
heroku config:set NODE_ENV=development  # set environment variable
heroku apps:rename <new_name>           # rename a heroku project; changes URL
```
