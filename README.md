# Character 0.9-alpha

### TODO

* optimize image size for posts;
* auto save posts;
* save changes on cmd+s;
* image uploading improvements, progressbar, on drop style, order;
  http://tympanus.net/Development/ProgressButtonStyles/
* forms: hide errors when update is succesful;
* source view for pages and posts;
* update tests;


## Setup new [Rails 4](http://rubyonrails.org) project

    rails new ProjectName -T -O

Add gems to the ```Gemfile```:

    # ORM + Character
    gem 'mongoid',             github: 'mongoid/mongoid'
    gem 'carrierwave-mongoid', github: 'carrierwaveuploader/carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'mongoid-grid_fs',     github: 'ahoward/mongoid-grid_fs'
    gem 'character',           github: 'slate-studio/character'

Run bundle and run generators:

    bundle ; rails g mongoid:config ; rails g character:install


## Routes

- mount_character_instance
- mount_posts_at
- mount_pages_at

## Admin Modules

- chr.genericModule()
- chr.postsModule()
- chr.pagesModule()
- chr.settingsModule()
- chr.settingsWebsite()
- chr.settingsPostCategories()
- chr.settingsAdmins()

## Models

- Character::Post
- Character::PostCategory
- Character::Page
- Character::Image
- Character::Settings::Variable
- Character::User

## Helpers

- Character::SitemapGeneratorHelper

## API

**[Character.Generic.DetailsView](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/generic/details.coffee) and [Character.Settings.DetailsView](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/settings/details.coffee)**

These are blank methods that could be overriden to extend view functionality. Example of ```Character.Generic.DetailsView``` override: [character/posts/module.coffee](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/posts/module.coffee)

- @beforeRenderContent()
- @afterRenderContent()
- @beforeOnSave()
- @beforeFormSubmit(arr, $form, options)
- @afterFormSubmitSuccess(responseText, statusText, xhr, $form)
- @beforeOnClose()
- @afterOnClose()

## Character Instances

### Tools that could be useful

* Figure out if we can build apps easier on a top of http://harpjs.com
* See if we can make use of this: https://github.com/elclanrs/jq-idealforms
* Nice autocompletion tool: http://ichord.github.io/At.js/
* For touch devices (no need for jQuery UI): http://pornel.net/slip/ http://pornel.net/slip/
* Scrolling on iPad: http://iscrolljs.com/
* Add to blog: https://github.com/jansepar/picturefill
* For user input: https://github.com/loadfive/knwl.js
* Touch guestures: http://eightmedia.github.io/hammer.js/
* Spinner: http://viduthalai1947.github.io/loaderskit/
* Maybe we can include spinner in autoform generator: http://xixilive.github.io/jquery-spinner
* Blog post layout templates: http://adobe-webplatform.github.io/css-regions-polyfill/
* Might be used for subscription thing: http://andyatkinson.com/projects/promoSlide
* Email template: https://github.com/leemunroe/html-email-template
* Dropdown and select box: http://github.hubspot.com/tether/docs/welcome/

## Future Features

* preload forms on hover
* remove blink when new object created
* no page refresh on login;
* posterous posting options via email (https://posthaven.com/)