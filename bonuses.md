# Bonus LAB Material

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
