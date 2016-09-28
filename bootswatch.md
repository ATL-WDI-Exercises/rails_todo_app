# Add a Nice Bootswatch Theme

In this step we will add a [Bootswatch](https://bootswatch.com/) theme to our project, but instead of copying the bootswatch css into our project we will use a SASSy version of Bootswatch called [Bootswatch-Sass](https://github.com/log0ymxm/bootswatch-scss).

a. Create the following files:

* _superhero-variables.scss - content from [Superhero Variables](https://raw.githubusercontent.com/log0ymxm/bootswatch-scss/master/superhero/_variables.scss)
* _superhero.scss - content from [Superhero Overrides](https://github.com/log0ymxm/bootswatch-scss/blob/master/superhero/_bootswatch.scss)

b. Modify the imports in `app/assets/stylesheets/application.css.scss`:

```sass
@import "superhero-variables.scss";
@import "bootstrap-variables.scss";
@import "bootstrap-custom-variables.scss";
@import "bootstrap-sprockets.scss";
@import "bootstrap.scss";
@import "superhero.scss";
```

c. Modify `app/views/todos/index.html.erb` and replace

```html
<table class="table table-striped table-bordered table-hover">
```

with

```html
<table class="table table-hover">
```

d. Save your work:

```bash
git add -A
git commit -m "Added superhero Bootswatch theme."
git tag bootswatch
```
