## Character (α)

**IN DEVELOPMENT**

Data management framework based on [Backbone.js](http://backbonejs.org/) & [Marionette.js](https://github.com/marionettejs/backbone.marionette) written in CoffeeScript, using [Rails Framework](http://rubyonrails.org/) on the back-end. Front-end is based on [Foundation 4](http://foundation.zurb.com/) framework.

Main goal to create easy to use set of development tools to empower administration applications with a clean and simple user interfaces.

![Character Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-1.jpg)


### Index

* [Installation](#installation)
* [Configuration](#configuration)
  * [Step 1](#step-1)
  * [Step 2](#step-2)
  * [Step 3](#step-3)
* [Generic Application](#generic-application)
* [TODO](#todo)


### Installation

At the moment project is under very intence development so all sources are available on the [Github](https://github.com/slate-studio/character) only. When beta version is ready gems are going to be available on rubygems as well.

Add these to projects ```Gemfile```.

    gem 'character',          git: 'git://github.com/slate-studio/character.git'
    gem 'character_settings', git: 'git://github.com/slate-studio/character_settings.git'
    gem 'character_redactor', git: 'git://github.com/slate-studio/character_redactor.git'
    gem 'character_blog',     git: 'git://github.com/slate-studio/character_blog.git'

After running ```bundle``` you need to do basic configuration.


### Configuration

##### Step 1

Create asset files:

Character basic styles & overrides: ```app/assets/stylesheets/character.scss```

    @import "character/character";
    @import "character/blog";

    // Firefox font fix for production: replace www.website.com with the real address
    @font-face {
      font-family: 'FontAwesome';
      src: url("http://www.website.com/assets/fontawesome-webfont.eot");
      src: url("http://www.website.com/assets/fontawesome-webfont.eot?#iefix") format("embedded-opentype"), url("http://www.website.com/assets/fontawesome-webfont.woff") format("woff"), url("http://www.website.com/assets/fontawesome-webfont.ttf") format("truetype"), url("http://www.website.com/assets/fontawesome-webfont.svg#fontawesomeregular") format("svg");
      font-weight: normal;
      font-style: normal;
    }

Character initialization & configuration: ```app/assets/javascripts/character.coffee```

    #= require character/character
    #= require character/blog
    #= require jquery_nested_form
    #= require_self

Add assets to the ```config/environments/production.rb``` so they are prebuild on production:

    config.assets.precompile += %w( character.js character.css )


##### Step 2

Add ```mount_character_admin()``` routes mounter to ```config/routes.rb```, preferably on the top of the ```draw``` function.


##### Step 3

Setup character basic initializer: ```config/initializers/character```, provide only title for now:

    Character.configure do |config|
      config.title = 'Website Admin Title'
    end


### Generic Application


### TODO

. implement pagination interface in the generic app

. search option

. scopes

. add notifications to be shown after save action

. add hotkeys for fast navigation

. FIX: collection is rendered twice for some reason

. replace foundation topnav with original menu (layout/css)







