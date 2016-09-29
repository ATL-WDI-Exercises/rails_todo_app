# Deploying to Heroku

a. Make sure you have a Heroku account

See [Heroku Login](https://signup.heroku.com/login)

b. Download and install the Heroku Toolbelt

See [Heroku Toolbelt](https://toolbelt.heroku.com/)

> Note: older versions of Rails required that you add the `rails_12factor` gem before deploying. This is no longer necessary.

c. Specify a version of Ruby in the Gemfile

Rails 5 requires Ruby 2.2.0 or above. Heroku has a recent version of Ruby installed, however you can specify an exact version by using the ruby DSL in your Gemfile.

```
ruby "2.3.1"
```

d. Configure your git repo for Heroku, push to Heroku, and run a db:migrate remotely on Heroku:

```bash
heroku create
git config --list | grep heroku   # verify that the remote was added
git push heroku master
heroku run rake db:migrate
heroku open
```

## References

* [Heroku: Getting Started with Rails 5](https://devcenter.heroku.com/articles/getting-started-with-rails5)
