# Character (α)

**IN DEVELOPMENT**

Data management framework based on [Backbone.js](http://backbonejs.org/) & [Marionette.js](https://github.com/marionettejs/backbone.marionette) written in CoffeeScript, using [Rails Framework](http://rubyonrails.org/) on the back-end. Front-end is based on [Foundation 4](http://foundation.zurb.com/) framework.

Main goal to create easy to use set of development tools to empower administration applications with a clean and simple user interfaces.

![Character Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-1.jpg)

* [Installation](#installation)
* [Configuration](#configuration)
  * [Step 1: Assets](#step-1-assets)
  * [Step 2: Routes](#step-2-routes)
  * [Step 3: Initializer](#step-3-initializer)
* [Authentification](#authentification)
  * [Mozilla Persona](#mozilla-persona)
  * [Development Mode](#development-mode)
  * [Login Background](#login-background)
* [Generic Application](#generic-application)
* [List of Dependencies](#list-of-dependencies)
* [TODO](#todo)


## Installation

At the moment project is under very intence development so all sources are available on the [Github](https://github.com/slate-studio/character) only. When beta version is ready gems are going to be available on rubygems as well.

Add these to projects ```Gemfile```.

    gem 'character',          git: 'git://github.com/slate-studio/character.git'
    gem 'character_settings', git: 'git://github.com/slate-studio/character_settings.git'
    gem 'character_redactor', git: 'git://github.com/slate-studio/character_redactor.git'
    gem 'character_blog',     git: 'git://github.com/slate-studio/character_blog.git'

After running ```bundle``` you need to do basic configuration.


## Configuration

#### Step 1: Assets

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
    #= require_self

Add assets to the ```config/environments/production.rb``` so they are prebuild on production:

    config.assets.precompile += %w( character.js character.css )


#### Step 2: Routes

Add ```mount_character_admin()``` routes mounter to ```config/routes.rb```, preferably on the top of the ```draw``` function.


#### Step 3: Initializer

Setup character basic initializer: ```config/initializers/character```, provide only title for now:

    Character.configure do |config|
      config.title = 'Website Admin Title'
    end


## Authentification

#### Mozilla Persona

Character is using [Mozilla Persona](https://login.persona.org/about) as main authentification system. This one chosen as it is very easy to setup and allows us to do not create administrative accounts from one project to another.

There is a rake task that creates administrative account:

    rake admin:add_user[admin@email.com]


#### Development Mode

Persona is javascript based and it validates session everytime application is loaded. There is a way to disable Persona in development mode by adding the following line to Character configuration file ```config/initializers/character.rb```:

    config.no_auth_on_development = true

When ```no_auth_on_development``` flag is set first admin user used as as current account. At least one account should be created, but it shoudn't be a real persona account.


#### Login Background

Default login background could be changed using ```config.login_background_image``` option in Character configuration file ```config/initializers/character.rb```.


## Generic Application

![Character Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-2.jpg)


## List of Dependencies

* [jQuery](https://github.com/rails/jquery-rails)
* [Underscore](https://github.com/rweng/underscore-rails)
* [Underscore String](https://github.com/epeli/underscore.string)
* [Backbone](http://backbonejs.org/)
* [Backbone Marionette](https://github.com/chancancode/marionette-rails)
* [jQuery UI](https://github.com/joliss/jquery-ui-rails)
* [Eco](https://github.com/sstephenson/eco)
* [Compass](https://github.com/Compass/compass-rails)
* [Foundation](https://github.com/zurb/foundation/)
* [Fontawesome](https://github.com/bokmann/font-awesome-rails)
* [BrowserID](https://github.com/alexkravets/browserid-auth-rails)
* [Simple Form](https://github.com/plataformatec/simple_form)
* [Kaminari](https://github.com/amatsuda/kaminari)
* [Character Settings](https://github.com/slate-studio/character_settings)


## TODO

* implement pagination interface in the generic app
* search option
* scopes
* add notifications to be shown after save action
* add hotkeys for fast navigation
* FIX: collection is rendered twice for some reason
* replace foundation topnav with original menu (layout/css)
* annotated source

--
[Александр Кравец](http://www.akravets.com) @ [Slate](http://www.slatestudio.com) - August 5, 2013



