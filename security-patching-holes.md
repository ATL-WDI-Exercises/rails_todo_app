# Patch Security Holes

## Edit `app/controllers/users_controller.rb` and do the following:

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

## Edit `app/controllers/todos_controller.rb` and do the following:

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
