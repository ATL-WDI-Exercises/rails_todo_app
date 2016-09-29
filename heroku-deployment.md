# Deploying to Heroku

a. Make sure you have a Heroku account

See [Heroku Login](https://signup.heroku.com/login)

b. Download and install the Heroku Toolbelt

See [Heroku Toolbelt](https://toolbelt.heroku.com/)

c. Add the `rails_12factor` gem to the `Gemfile`:

```ruby
gem 'rails_12factor', group: :production
```

Then run `bundle install` and save your work:

```bash
bundle install
git add -A
git commit -m "Added rails_12factor"
```

d. Configure your git repo for Heroku, push to Heroku, and run a db:migrate remotely on Heroku:

```bash
heroku create
git push heroku master
heroku run rake db:migrate
heroku open
```
