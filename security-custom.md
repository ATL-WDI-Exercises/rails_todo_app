# Adding Custom Security to our TODOs App

## Step 0 - Create a Branch

```bash
git checkout -b security-custom
```

## Step 1 - Add MVC CRUD for User

To add AuthN/AuthZ and Session Management, we first need to add a User model and its associated MVC CRUD operations to our app.

1a. Scaffold out the MVC CRUD for a User

```bash
rails g scaffold user first_name:string last_name:string email:string:uniq password_digest:string remember_token:string
```

1b. Edit the `create_users` migration script and add `null: false` to the
`first_name`, `last_name`, `email`, and `password_digest` columns.

1c. Create a migration to add a relationship from `todo` to `user`:

```bash
rails g migration AddUserRefToTodos user:references
```

1d. Edit the `add_user_ref_to_todos` migration script and add a not-null constraint: `null: false`

1e. Run the migrations:

```bash
rake db:migrate
```

and inspect the file `db/schema.rb` to ensure that the model / table looks correct.

1f. Edit `app/models/user.rb` and add the following:

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

1g. Edit `app/models/todo.rb` and add the following line:

```ruby
belongs_to :user
```

1h. Edit `app/controllers/users_controller.rb` and near the bottom replace the following line:

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

1i. Edit `app/views/users/_form.html.erb` and change the `password_digest` and `remember_token` input labels and fields to:

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

1j. Edit `app/views/users/edit.html.erb` and remove the `Back` button

1k. Edit `app/views/users/new.html.erb` and remove the `Back` button and replace `<h1>New user</h1>` with `<h1>Sign Up</h1>`

1l. Edit `app/views/users/show.html.erb` and remove the `Back` button and the `password_digest` and `remember_token` fields.

1m. Save your work:

```bash
git add -A
git commit -m "Added MVC CRUD for User"
git tag security-custom-step1
```

---

### Step 2 - Create a Sessions Controller

In this step we will create a `SessionsController` to handle our *sign-in* via its `new` and `create` actions and *sign-out* via its `destroy` action. We will also modify the `UsersController` so that its `new` and `create` actions will handle *sign-up* (i.e. registration). We will also create a `SessionsHelper` module to provide common authentication and session management support. Finally we will add dynamically controlled navigation links so that the appropriate links appear on the `navbar` depending on whether the user is currently signed in.

2a. Create `app/controllers/sessions_controller.rb` and `app/views/sessions/new.html.erb`

```bash
rails g controller sessions new create destroy
```

2b. Edit `app/views/sessions/new.html.erb` and insert the following content:

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

2c. Add the following to `app/helpers/sessions_helper.rb`:

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

2d. Edit `app/controllers/sessions_controller.rb` to have the following content:

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

2e. Edit `app/controllers/users_controller.rb`:

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

2f. Edit `config/routes.rb` and replace

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

2g. Edit `app/controllers/application_controller.rb` and add the following line:

```ruby
  include SessionsHelper
```

2h. Edit `app/controllers/static_pages_controller.rb` and add a redirect to the
  `home` action:

```ruby
  def home
    redirect_to todos_path if signed_in?
  end
```

2i. Edit `app/controllers/todos_controller.rb`:

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

2j. Update `app/views/layouts/_navigation_links.html.erb` to match the following:

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

2k. Edit `app/views/static_pages/home.html.erb` and add the following buttons to the bottom of the jumbotron:

```html
  <br/>
  <%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
  <%= link_to "Sign in",      signin_path, class: "btn btn-large btn-primary" %>
```

2l. Save your work:

```bash
git add -A
git commit -m "Create the Sessions Controller, Sessions Helper, and navigation links."
git tag security-custom-step2
```
