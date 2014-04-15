# Character Rails Admin

![Character Image](http://character.s3.amazonaws.com/character1.jpg)

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

## Modules

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

## Shortcuts

- CMD+s — save changes
- CMD+e — toggle fullscreen

## API

**[Character.Generic.DetailsView](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/generic/details.coffee) and [Character.Settings.DetailsView](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/settings/details.coffee)**

These are blank methods that could be overriden to extend view functionality. Example of ```Character.Generic.DetailsView``` override: [character/posts/module.coffee](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/posts/module.coffee)

- @beforeContentRequest()
- @beforeRenderContent()
- @beforeFormHelpersStart()
- @afterRenderContent()
- @beforeSave()
- @beforeFormSubmit(arr, $form, options)
- @afterFormSubmitSuccess(responseText, statusText, xhr, $form)
- @beforeOnClose()
- @afterOnClose()

## Instances

## Analytics

* Create a new project (```GA_APP_NAME```) at: [https://console.developers.google.com/project](https://console.developers.google.com/project)
* Enable Analytics under **APIs & auth** -> **APIs** -> Analytics API
* Create another client under **Credentials**
* Download and put **key-file** (```GA_KEY_FILE_NAME```) to your projects ```config``` folder
* Go to you (Analytics)[www.google.com/analytics] account and add the **Service account** email address to your account (```GA_SERVICE_ACCOUNT_EMAIL```). It should be something like ```something-long@developer.gserviceaccount.com```.

Set all variables in server environment:

- ```GA_APP_NAME```
- ```GA_SERVICE_ACCOUNT_EMAIL```
- ```GA_KEY_FILE_NAME```
- ```GA_PROFILE_ID```

### Tools

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