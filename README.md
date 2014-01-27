# Character

Character is an admin framework for **rails + mongoid** web applications. It has clean user interface and written with CoffeeScript. Character is very similar to [Django](http://djangoproject.com) admin or [Active Admin](http://www.activeadmin.info) but is much easier to extend. It is built on the top of:

* Back-end: [Rails](http://rubyonrails.org)
* Front-end Javascript: [Backbone.js](http://backbonejs.org) + [Marionette.js](https://github.com/marionettejs/backbone.marionette)
* Front-end CSS: [Foundation 5](http://foundation.zurb.com)

![Character Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-1.jpg)

## Content

* [New Project](#new-project)
* [Authentification](#authentification)
  * [Mozilla Persona](#mozilla-persona)
  * [Login Background](#login-background)
* [Generic App](#generic-app)
  * [Model Admin](#model-admin)
  * [Forms](#forms)
* [Instances](#instances)
* [Settings](#settings)
* [Tests](#tests)
* [TODO](#todo)


## New Project

Start new Rails 4 project:

    rails new ProjectName -T -O

Add following gems to the ```Gemfile```:

    # ORM
    gem 'mongoid', github: 'mongoid/mongoid'
    gem 'bson_ext'

    # File uploader
    gem 'carrierwave-mongoid', github: 'carrierwaveuploader/carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'mongoid-grid_fs',     github: 'ahoward/mongoid-grid_fs'

    gem 'character', github: 'slate-studio/character'
    gem 'character_redactor',  github: 'slate-studio/character_redactor'

Run ```bundle``` from projects root.

Create mongo database config, initialize Foundation (not required if it's not used in the project) and install Character assets:

    rails g mongoid:config ; rails g foundation:install ; rails g character:install

Run local Rails server:

    rails s

Done! Open [http://localhost:3000/admin](http://localhost:3000/admin) in the browser.

Character generator does:

1. Mount character in the ```config/routes.rb``` with ```mount_character()``` command
2. Create ```app/assets/javascript/admin.coffee``` and ```app/assets/stylesheets/admin.scss```
3. Remove ```//= require_tree .``` and ```*= require_tree .``` string from ```app/assets/javascripts/application.js``` and ```app/assets/stylesheets/application.js``` — to do not include admin assets in the application assets
4. Add character & foundation javascript assets to production environment in ```config/environment/production.rb```: ```config.assets.precompile += %w( admin.js admin.css foundation.js vendor/modernizr.js )```
5. Create character initializer ```config/initializers/character.rb```


### Blog

Character includes basic blog application. To install blog please install character admin using instructions above. And then run blog generator:

    rails g character:blog:install

Done! Open [http://localhost:3000/](http://localhost:3000/) in the browser.

## Authentification


#### Mozilla Persona

Character is using [Mozilla Persona](https://login.persona.org/about) as main authentification system. This one chosen as it is very easy to setup and allows us to do not create administrative accounts from one project to another.

While logging to Character for the first time, first administrative account is created. Add other accounts via console or using Character / Settings / Admins tab.


#### Login Background

Default login background could be changed using ```config.login_background_image``` option in Character configuration file ```config/initializers/character.rb```.

![Character Default Login](https://raw.github.com/slate-studio/character/master/doc/img/demo-3.jpg)


## Generic App

Generic application is a main type of Character apps. It provides a way to setup administrative application for any [Mongoid](http://mongoid.org/en/mongoid/index.html) model in no time.

[Generic Application API Reference](https://github.com/slate-studio/character/blob/master/doc/generic_app.md)

![Character Generic Application Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-2.jpg)


#### Model Admin

Here is an example of adding character admin app for ```Project``` model from the screenshot above. All model setups are added to ```app/assets/javascripts/admin.coffee```:

    new CharacterApp 'Project',
      icon:         'rocket'
      reorder:      true
      scopes:
        default:
          order_by: '_position:desc'

Projects app added to character with ```rocket``` menu icon from [Fontawesome Icons](http://fontawesome.io/icons/), default sort order uses ```_position``` model field, and items are reorderable in the list with drag'n'drop to make it possible to reorder projects from the portfolio page.


#### Forms

By default object forms are autogenerated, [here](https://github.com/slate-studio/character/blob/master/app/views/character/generic_form.html.erb) is a template with is used to do that. At this point it's very simple generator and we have a plan to make more sophisticated. So you might want to customize objects form and it's pretty easy to do this.

Character looks for forms templates at ```app/views/character/[pluralized_model_name]/form.html.erb```, so in the example above form should be placed at: ```app/views/character/projects/form.html.erb```. Generic template is good to start customization with:

    <%= simple_form_for @object, url: @form_action_url do |f| %>
      <div class='row'>
        <% @form_fields.each do |name| %>
          <%= f.input name, wrapper_class: 'small-12 columns' %>
        <% end %>
      </div>
    <% end %>

[Simple Form](https://github.com/plataformatec/simple_form) and [Nested Form](https://github.com/ryanb/nested_form) could be used for building forms.

[Nested Form](https://github.com/ryanb/nested_form) is a very handy gem to expand forms with editable inlines. It plays very nice with Character. Customized form could include nested forms. Following screenshot shows part of the Project form -- editable list of embeded images into the Project model handled by [Nested Form](https://github.com/ryanb/nested_form).

![Character Nested Forms Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-4.jpg)


## Instances

Instances allow you to use several independent character app instances for one website. Each of them will be using separate configuration, styles and templates.

[See instances section for details](https://github.com/slate-studio/character/blob/master/doc/instances.md)


## Settings

Settings application provides a generic way of expanding admin with editable sets of parameters (objects) or editable collections. One of good examples of usage of settings app is an admin application which allows to add/remove admin users:

![Character Nested Forms Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-5.jpg)

Settings could be used to provide a simple way of editing CTAs, webpage editable content, etc. Read more on Character Settings [here](https://github.com/slate-studio/character/blob/master/doc/settings.md).


## Tests

To run the tests use the following command in the gem's root directory:

    $ rspec


--
* [Олександр Кравець](http://www.akravets.com) @ [Slate](http://www.slatestudio.com) - January 23, 2014
* Роман Лупійчук @ [Slate](http://www.slatestudio.com) - August 9, 2013
* Мельник Максим @ [Slate](http://www.slatestudio.com) - October 23, 2013

## Notes

* Figure out if we can build apps easier on a top of http://harpjs.com
* Maybe we can include spinner in autoform generator: http://xixilive.github.io/jquery-spinner
* See if we can make use of this: https://github.com/elclanrs/jq-idealforms
* Nice autocompletion tool: http://ichord.github.io/At.js/
* For touch devices (no need for jQuery UI): http://pornel.net/slip/
* Scrolling on iPad: http://iscrolljs.com/
* Add to blog: https://github.com/jansepar/picturefill
* For user input: https://github.com/loadfive/knwl.js
* Touch guestures: http://eightmedia.github.io/hammer.js/
* Spinner: http://viduthalai1947.github.io/loaderskit/