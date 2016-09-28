# TODO CRUD App in Rails with Scaffolding and Home Grown AuthN and AuthZ

{{ TOC }}

## Introduction

This is a simple Rails App for a TODO list. This app uses the following technologies:

* [Ruby 3.1](https://www.ruby-lang.org/)
* [Rails 5.0](http://rubyonrails.org/)
* [PostgreSQL 9.5](http://www.postgresql.org/)
* [Twitter Bootstrap 3.3](http://getbootstrap.com/)
* [SASS 3.4](http://sass-lang.com/)
* [bootstrap-generators 3.3](https://github.com/decioferreira/bootstrap-generators)

We begin by building a simple Rails TODO app that uses SASS and Twitter Bootstrap for styling, and then add Authentication, Session Management, and Authorization.

### Scaffolding

![Scaffold](images/scaffold.jpg)

Scaffolding is a _controversial_ subject because of the amount of _magic_ going on, but it is a tool that you should be familiar with.

![images](images/rails-scaffold-oh-no-you-didnt.gif)

#### What is scaffolding?

_scaffold_: a temporary metal or wooden framework that is used to support workmen and materials during the erection, repair, etc, of a building or other construction.

In _software development_ `scaffolding` is the generation of code that defines the basic structure of a project or feature, allowing for a quicker implementation of the final solution.

> _Scaffolding_ is possible when many aspects of the project or feature follow a pre-defined structure (i.e. convention over configuration).

### Security

For educational purposes we are not using a 3rd party authentication library but we instead will build our own authentication and authorization as we go. For those who would like to investigate a 3rd party library for authentication and authorization, I recommend taking a look at [Devise](http://devise.plataformatec.com.br/).

## Steps to reproduce

### Step 1 - Generate The Project

1a. Generate a new Rails project and initialize the GIT repo:
> Note that the `rails new` command will create a new subdirectory for you.

```bash
rails new --database=postgresql --skip-test rails_todo_app
cd rails_todo_app
rake db:create
```

1b. Save your work

git init
git add -A
git commit -m "Created Rails project."
git tag step1
```

### Step 2 - Add Gems

In this step we add some nice gems to help us with Rails development:

* [bootstrap-generators](https://github.com/decioferreira/bootstrap-generators) - adds Twitter Bootstrap styling to our rails generated views, see further discussion in Step 3 below.
* [pry-rails](https://github.com/rweng/pry-rails) - causes `rails console` to open `pry` instead of `irb`
* [better_errors](https://github.com/charliesome/better_errors) - provides improved Rails error pages

2a. Edit the `Gemfile` and add the following gems:

```ruby
gem 'bootstrap-generators', '~> 3.3.4'
gem 'record_tag_helper', '~> 1.0'

gem 'bcrypt', '~> 3.1.7'                # uncomment this line

group :development, :test do
  # Use pry with Rails console
  gem 'pry-rails'

  # Better Rails Error Pages
  gem 'better_errors'
end
```

2b. Run bundler and Save your work:

```bash
bundle install
git add -A
git commit -m "Added gems."
git tag step2
```

### Step 3 - Configure Scaffold Generator

For this project we will be using rails generators to scaffold some of our MVC code. We will also be using the SASS/SCSS version of [Twitter Bootstrap](http://getbootstrap.com/) for styling.

Unfortunately, the out-of-the-box rails _scaffold_ generators produce views that are not easily compatible with Twitter Bootstrap. So we need to customize the generators to produce view code that contains Bootstrap styling. Fortunately there exist a gem called [bootstrap-generators](https://github.com/decioferreira/bootstrap-generators) that will assist us in this task.

3a. Install the custom templates:

```bash
rails generate bootstrap:install -f
```

3b. Add the following to `config/application.rb`:

```ruby
module TodoApp
  class Application < Rails::Application

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
    end
```

3c. Save your work:

```bash
git add -A
git commit -m "Configured custom templates for Scaffolding"
git tag step3
```

### Step 4 - Configure the Project for SASS and Bootstrap

We will be using SASSy CSS (SCSS) for our styling and importing the Twitter Bootstrap SCSS files into our main `application.css.scss` file.

The `bootstrap:install` command from Step 3 created the files `app/assets/stylesheets/bootstrap-generators.scss` and `app/assets/stylesheets/bootstrap-variables.scss`. We will be removing `app/assets/stylesheets/bootstrap-generators.scss` and putting that code in our `application.css.scss` file. We will also rename `app/assets/stylesheets/bootstrap-variables.scss` to add an '_' prefix to the name to signify that it is a SASS partial file.

We will also create the file `app/assets/stylesheets/_bootstrap-custom-variables.scss` to hold any custom Bootstrap variables assignments we may want to define.

4a. Refactor the SCSS files:

```bash
mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss
rm app/assets/stylesheets/bootstrap-generators.scss
mv app/assets/stylesheets/bootstrap-variables.scss app/assets/stylesheets/_bootstrap-variables.scss
touch app/assets/stylesheets/_bootstrap-custom-variables.scss
```

4b. Repace the contents of `app/assets/stylesheets/application.css.scss` with the following:

```sass
{{ rails_todo_app/app/assets/stylesheets/application.css.scss }}
```

4c. Put the following content inside the file `app/assets/stylesheets/_bootstrap-custom-variables.scss`:

```sass
{{ rails_todo_app/app/assets/stylesheets/_bootstrap-custom-variables.scss }}
```

4d. Save your work:

```bash
git add -A
git commit -m "Configured for Bootstrap SASS"
git tag step4
```

### Step 5 - Create a Static Pages Controller and Views, the NavBar, and the Flash Messages Support

We will generate a `static-pages-controller` and its related views that define two static pages: a *home* page and an *about* page. We will also move the *navbar* that was generated in Step 2 via the `rails generate bootstrap:install -f` command into a separate `html` partial file along with creating a partial file to hold just the *navbar* links. Finally we will create a *messages* `html` partial file for styling the Rails generated flash messages / alerts that indicate when an action was successful or failed.

5a. Generate the `static-pages-controller` and its related views:

```bash
rails g controller static_pages home about
```

5b. Edit `config/routes.rb` and replace the `static_pages` routes with the following:

```ruby
  root to: 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'about', to: 'static_pages#about', as: 'about'
```

5c. Edit `app/views/static_pages/home.html.erb` and replace the content with:

```html
{{ rails_todo_app/app/views/static_pages/home.html.erb }}
```

5d. Edit `app/views/static_pages/about.html.erb` and replace the content with:

```html
{{ rails_todo_app/app/views/static_pages/about.html.erb }}
```

5e. Edit `app/views/layouts/application.html.erb` to set a dynamic title and replace the body with that provided below:

```html
    <title><%= full_title(yield(:title)) %></title>
```

```html
  <body>
    <header>
      <%= render 'layouts/navigation' %>
    </header>
    <main role="main" class="container-fluid">
       <%= render 'layouts/messages' %>
       <%= yield %>
    </main>
  </body>
```

5f. Create the file `app/views/layouts/_navigation.html.erb` with the following content:

```html
{{ rails_todo_app/app/views/layouts/_navigation.html.erb }}
```

5g. Create the file `app/views/layouts/_navigation_links.html.erb` with the following content:

```html
<li><%= link_to 'About', '/about' %></li>
```

5h. Create the file `app/views/layouts/_messages.html.erb`:

```html
{{ rails_todo_app/app/views/layouts/_messages.html.erb }}
```

5i. Edit the file `app/helpers/application_helper.rb` and set the content to:

```ruby
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "TODOs"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
```

5j. Test it out

* Run the server with `rails s`.
* In your browser, load `localhost:3000`.
* Use the NavBar to navigate between the `home` route and the `about` route.
* Verify that the body background color is blue. Try changing it to another color (edit `app/assets/stylesheets/_bootstrap-custom-variables.scss` and refresh your browser tab). You can also comment out the line if you want the default Bootstrap body color.

5k. Save your work:

```bash
git add -A
git commit -m "Added static pages, navbar, and flash messages."
git tag step5
```

### Step 6 - Add MVC CRUD for the TODOs

We are finally ready to generate the MVC CRUD code for our TODOs list.

6a. Generate the MVC CRUD for TODOs:

Now for the _magic_ of scaffolding. We are going to use a _single command_ to create our model, controller, views, and the 7 RESTful routes! Furthermore, our controller methods and views will be fully functional!

```bash
rails g scaffold todo title:string completed:boolean
```

> Check out those controller methods and all of the views! Everything is there and is generated to work with Twitter Bootstrap!

6b. Edit `db/migrate/<migration_script_name>` and add `null: false` to the
`title` and `completed` columns, for instance:

```ruby
      t.string :title, null: false
      t.boolean :completed, null: false
```

6c. Run the migration:

```bash
rake db:migrate
```

> Inspect the `config/routes.rb` file. A single line was added to configure
the 7 routes for our TODOs resource. That's nice!!!

6d. Edit `app/models/todo.rb` and replace the contents with the following:

```ruby
{{ rails_todo_app/app/models/todo.rb }}
```

6e. Edit `app/views/layouts/_navigation_links.html.erb` and add a link to our todos view:

```html
<li><%= link_to 'TODOs', todos_path %></li>
```

6f. Edit `app/views/todos/index.html.erb` and

* edit the `<h1>` tag
* add a `todos` CSS class to the outer `div`
* add the `Show`, `Edit`, and `Destroy` labels on the table headers
* replace the boolean `completed` value with a link and an icon

```html
<h1>Here are your TODOs</h1>
...
<div class="table-responsive todos">
...
        <th>Show</th>
        <th>Edit</th>
        <th>Destroy</th>
...
        <!-- <td><%= todo.completed %></td> -->
        <td>
        <%= link_to("/todos/#{todo.id}/toggle_completed") do %>
          <% if todo.completed %>
            <span class="glyphicon glyphicon-ok"></span>
          <% else %>
            <span class="glyphicon glyphicon-unchecked"></span>
          <% end %>
         <% end %>
        </td>
```

6g. Edit `app/views/todos/show.html.erb` and add the created_at attribute:

```html
  <dt>Created:</dt>
  <dd><%= @todo.created_at %></dd>
```

6h. Edit `app/controllers/todos_controller.rb`

* replace
`@todos = Todo.all` with
`@todos = Todo.order(created_at: :desc)`

* replace all occurrances of
`redirect_to @todo` and `redirect_to todos_url` with
`redirect_to todos_path`

* add a `toggle_completed` method:

```ruby
def toggle_completed
  @todo.completed = !@todo.completed
  respond_to do |format|
    if @todo.save
      format.html { redirect_to todos_path }
      format.json { render :show, status: :ok, location: @todo }
    else
      format.html { render :index }
      format.json { render json: @todo.errors, status: :unprocessable_entity }
    end
  end
end
```

* add the `toggle_completed` method to the `before_action` that is calling the `set_todo` method:

```ruby
before_action :set_todo, only: [:show, :edit, :update, :destroy, :toggle_completed]
```

6i. Add a route for the `toggle_completed` action:

Edit `config/routes.rb` and add the following line:

```ruby
  get 'todos/:id/toggle_completed', to: 'todos#toggle_completed', as: 'toggle'
```

6j. Test it out

* Run the server with `rails s`.
* In your browser, load `localhost:3000`.
* Navigate to the TODOs route via the NavBar
* Try creating, viewing, updating, and deleting some TODOs.

6k. Save your work:

```bash
git add -A
git commit -m "Created MVC CRUD for a list of TODOs."
git tag step6
```

### Intermission

Let's reflect on what we have done:

* Created a Rails app
* Added some favorite gems
* Added custom scaffolding templates
* Configured for Bootrap and SASS
* Created some static pages, a navbar, and flash message support
* Created MVC CRUD for a list of TODOs

But we have one *major* problem:

> How do we support multiple users each with their own TODO list?

To do that we need to add Authentication, Authorization, and Session Management to our app. But first, lets discuss some security concepts:

Let's talk about login id, passwords and session management:

* login_id               - we will use their email address
* password complexity    - we will use a REGEX
* password digest        - a one-way encryption so that passwords are not stored in plain text
* password confirmation  - make sure the user correctly creates their password
* keep user sessions     - use browser cookie containing a `remember_token` that is persisted in database

### Step 7 - Add MVC CRUD for User

To add AuthN/AuthZ and Session Management, we first need to add a User model and its associated MVC CRUD operations to our app.

7a. Scaffold out the MVC CRUD for a User

```bash
rails g scaffold user first_name:string last_name:string email:string:uniq password_digest:string remember_token:string
```

7b. Edit the `create_users` migration script and add `null: false` to the
`first_name`, `last_name`, `email`, and `password_digest` columns.

7c. Create a migration to add a relationship from `todo` to `user`:

```bash
rails g migration AddUserRefToTodos user:references
```

7d. Edit the `add_user_ref_to_todos` migration script and add a not-null constraint: `null: false`

7e. Run the migrations:

```bash
rake db:migrate
```

and inspect the file `db/schema.rb` to ensure that the model / table looks correct.

7f. Edit `app/models/user.rb` and add the following:

```ruby
class User < ActiveRecord::Base

  has_many :todos, dependent: :destroy

  before_save { email.downcase! }

  validates :first_name, :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 80 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # Add methods to set and authenticate against a BCrypt password.
  has_secure_password

  validates :password, length: { minimum: 8, maximum: 20 }

  validate :password_complexity

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

  def to_s
    email
  end
end
```

7g. Edit `app/models/todo.rb` and add the following line:

```ruby
belongs_to :user
```

7h. Edit `app/controllers/users_controller.rb` and near the bottom replace the following line:

```ruby
params.require(:user).permit(:first_name,
                             :last_name,
                             :email,
                             :password_digest,
                             :remember_token)
```

with

```ruby
params.require(:user).permit(:first_name,
                             :last_name,
                             :email,
                             :password,
                             :password_confirmation)
```

7i. Edit `app/views/users/_form.html.erb` and change the `password_digest` and `remember_token` input labels and fields to:

```html
  <div class="form-group">
    <%= f.label :password, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.password_field :password, class: "form-control" %>
    </div>
  </div>
  <div class="form-group">
    <%= f.label :password_confirmation, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.password_field :password_confirmation, class: "form-control" %>
    </div>
  </div>
```

7j. Edit `app/views/users/edit.html.erb` and remove the `Back` button

7k. Edit `app/views/users/new.html.erb` and remove the `Back` button and replace `<h1>New user</h1>` with `<h1>Sign Up</h1>`

7l. Edit `app/views/users/show.html.erb` and remove the `Back` button and the `password_digest` and `remember_token` fields.

7m. Save your work:

```bash
git add -A
git commit -m "Added MVC CRUD for User"
git tag step7
```

### Step 8 - Create a Sessions Controller

In this step we will create a `SessionsController` to handle our *sign-in* via its `new` and `create` actions and *sign-out* via its `destroy` action. We will also modify the `UsersController` so that its `new` and `create` actions will handle *sign-up* (i.e. registration). We will also create a `SessionsHelper` module to provide common authentication and session management support. Finally we will add dynamically controlled navigation links so that the appropriate links appear on the `navbar` depending on whether the user is currently signed in.

8a. Create `app/controllers/sessions_controller.rb` and `app/views/sessions/new.html.erb`

```bash
rails g controller sessions new create destroy
```

8b. Edit `app/views/sessions/new.html.erb` and insert the following content:

```html
<% provide(:title, "Sign in") %>
<h1>Sign in</h1>

<div class="row">
  <div class="span6 offset3">
    <%= form_for(:session, url: sessions_path) do |f| %>

      <%= f.label :email %>
      <%= f.text_field :email %>

      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.submit "Sign in", class: "btn btn-large btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  </div>
</div>
```

8c. Add the following to `app/helpers/sessions_helper.rb`:

```ruby
module SessionsHelper

  def sign_in(user)
    # save a cookie on their computer
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    # update our database with their cookie info
    user.update_attribute(:remember_token, User.digest(remember_token))
    # set a current_user variable equal to user
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  # set the current_user from the remember_token cookie
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token  = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  # check if the specified user is the current user
  def current_user?(user)
    user == current_user
  end

  # security check, ensure user is signed in, if not, redirect to signin page.
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # redirect back to the original requested view or to default
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # store the current location to support the redirect_back feature
  def store_location
    session[:return_to] = request.url if request.get?
  end
end
```

8d. Edit `app/controllers/sessions_controller.rb` to have the following content:

```ruby
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or todos_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
```

8e. Edit `app/controllers/users_controller.rb`:

Modify the `create` method to call the `sign_in` helper method and change the `redirect_to` target path and notice:

```ruby
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to root_path, notice: 'Welcome!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
```

8f. Edit `config/routes.rb` and replace

```ruby
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
```
with

```ruby
  resources :sessions, only:[:new, :create, :destroy]
```

and add the following:

```ruby
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
```

8g. Edit `app/controllers/application_controller.rb` and add the following line:

```ruby
  include SessionsHelper
```

8h. Edit `app/controllers/static_pages_controller.rb` and add a redirect to the
  `home` action:

```ruby
  def home
    redirect_to todos_path if signed_in?
  end
```

8i. Edit `app/controllers/todos_controller.rb`:

* add `before_action :signed_in_user`
* edit the `index` method:

```ruby
  def index
    @todos = current_user.todos.order(created_at: :desc)
  end
```

 * edit the `create` method to associate the user to a newly created Todo:

```ruby
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user       # associate the new todo to the current_user
    ...
```

8j. Update `app/views/layouts/_navigation_links.html.erb` to match the following:

```html
<% if signed_in? %>
  <li><%= link_to 'TODOs', todos_path %></li>
  <li><%= link_to @current_user, user_path(@current_user) %></li>
  <li><%= link_to 'Sign out', signout_path, method: 'delete' %></li>
<% else %>
  <li><%= link_to 'Sign up', signup_path %></li>
  <li><%= link_to 'Sign in', signin_path %></li>
<% end %>
<li><%= link_to 'About', '/about' %></li>
```

8k. Edit `app/views/static_pages/home.html.erb` and add the following buttons to the bottom of the jumbotron:

```html
  <br/>
  <%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
  <%= link_to "Sign in",      signin_path, class: "btn btn-large btn-primary" %>
```

8l. Save your work:

```bash
git add -A
git commit -m "Create the Sessions Controller, Sessions Helper, and navigation links."
git tag step8
```

### Step 9 - Add a Nice Bootswatch Theme

In this step we will add a [Bootswatch](https://bootswatch.com/) theme to our project, but instead of copying the bootswatch css into our project we will use a SASSy version of Bootswatch called [Bootswatch-Sass](https://github.com/log0ymxm/bootswatch-scss).

9a. Create the following files:

* _superhero-variables.scss - content from [Superhero Variables](https://raw.githubusercontent.com/log0ymxm/bootswatch-scss/master/superhero/_variables.scss)
* _superhero.scss - content from [Superhero Overrides](https://github.com/log0ymxm/bootswatch-scss/blob/master/superhero/_bootswatch.scss)

9b. Modify the imports in `app/assets/stylesheets/application.css.scss`:

```sass
@import "superhero-variables.scss";
@import "bootstrap-variables.scss";
@import "bootstrap-custom-variables.scss";
@import "bootstrap-sprockets.scss";
@import "bootstrap.scss";
@import "superhero.scss";
```

9c. Modify `app/views/todos/index.html.erb` and replace

```html
<table class="table table-striped table-bordered table-hover">
```

with

```html
<table class="table table-hover">
```

9d. Save your work:

```bash
git add -A
git commit -m "Added superhero Bootswatch theme."
git tag step9
```

### Bonus LAB Material

* Check for security holes and fix them:
  - See what routes a user can manually enter into the browser even if the
    user is not logged in
  - Can a user edit the account of another user? Can a user change another
    user's password?
  - See if a user can manually enter the URL for a TODO that is not one of
    their TODOs. Can the user edit or delete TODOs that they do not own?
* Change the UX:
  - Add a nice background image.
  - Try using other Bootswatch themes.
  - Change the NavBar.
* Add some more information to a user, such as `phone`, `city` and `state`, `occupation`, etc.
* Add some more attributes to a TODO, such as a `due_date` and a `priority`.
* Add a set of `keywords` to a Todo. There should be a `many-to-many` relationship between `todos` and `keywords` and the code should *not* create duplicate keywords.
* Replace the manual authentication with a gem like [Devise](http://devise.plataformatec.com.br/).


### Step 10 - Patch Security Holes

10a. Edit `app/controllers/users_controller.rb` and do the following:

* Add the following before actions:

```ruby
   before_action :signed_in_user, only: [:index, :show, :edit, :update, :destroy]
   before_action :verify_correct_user, only: [:show, :edit, :update, :destroy]
```

* Add the `verify_correct_user` private method:

```ruby
     def verify_correct_user
       user = User.find_by(id: params[:id])
       redirect_to root_url, notice: 'Access Denied!' unless current_user?(user)
     end
```

10b. Edit `app/controllers/todos_controller.rb` and do the following:

* Add the following before actions:

```ruby
  before_action :signed_in_user
  before_action :set_todo, only: [:toggle_completed, :show, :edit, :update, :destroy]
  before_action :verify_correct_user, only: [:show, :edit, :update, :destroy]
```

* Add the `verify_correct_user` private method:

```ruby
     def verify_correct_user
       @todo = current_user.todos.find_by(id: params[:id])
       redirect_to root_url, notice: 'Access Denied!' if @todo.nil?
     end
```

### Step 11 - Deploy to Heroku

11a. Make sure you have a Heroku account - https://signup.heroku.com/login

11b. Download and install the Heroku Toolbelt - https://toolbelt.heroku.com/

11c. Add the `rails_12factor` gem to the `Gemfile`:

```ruby
gem 'rails_12factor', group: :production
```

Then run `bundle install` and save your work:

```bash
bundle install
git add -A
git commit -m "Added rails_12factor"
git tag step11
```

11d. Configure your git repo for Heroku, push to Heroku, and run a db:migrate remotely on Heroku:

```bash
heroku create
git push heroku master
heroku run rake db:migrate
heroku open
```

### Helpful Heroku Commands

#### Managing Your App

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

#### Debugging

```bash
heroku ps             # list process status of heroku processes
heroku releases       # list releases deployed to heroku for current app
heroku logs           # display logs for an app
heroku logs -n 1500   # default is 100 lines, but you can get up to 1500
heroku login          # authenticate with heroku so that you can connect
heroku run bash       # connect to heroku host machine
```

#### General Commands

```bash
heroku help                             # prints help
heroku list                             # list all of your heroku apps
heroku info                             # prints info about the heroku project
heroku config                           # prints heroku environment variables
heroku config:set NODE_ENV=development  # set environment variable
heroku apps:rename <new_name>           # rename a heroku project; changes URL
```
