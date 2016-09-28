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

---

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

---

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

---

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

---

### Step 3 - Configure Scaffold Generator

For this project we will be using rails generators to scaffold some of our MVC code. We will also be using the SASS/SCSS version of [Twitter Bootstrap](http://getbootstrap.com/) for styling.

Unfortunately, the out-of-the-box rails _scaffold_ generators produce views that are not easily compatible with Twitter Bootstrap. So we need to customize the generators to produce view code that contains Bootstrap styling. Fortunately there exist a gem called [bootstrap-generators](https://github.com/decioferreira/bootstrap-generators) that will assist us in this task.

3a. Install the custom templates:

We want to install custom _Bootstrap_ templates for our scaffold generator.

```bash
rails generate bootstrap:install -f
```

> The custom templates were installed in the folder `lib/templates/erb`. Feel free to check them out!

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

---

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

---

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

---

### Step 6 - Scaffold the Model, Views, Controller, and Routes for the TODOs

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

---

## Summary

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

---

### Adding Security

* [Custom Security](security-custom.md)
* [Devise Security](security-devise.md)

---

### For Further Development

* [Add a Bootswatch Theme](bootswatch.md)
* [Bonuses](bonuses.md)
* [Deploying to Heroku](heroku-deployment.md)
* [Helpful Heroku Commands](heroku-notes.md)
