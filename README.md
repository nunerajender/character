# Character


## Setup new project (Rails 4)

    rails new ProjectName -T -O

Add gems to the ```Gemfile```:

    # ORM + Character
    gem 'mongoid',             github: 'mongoid/mongoid'
    gem 'carrierwave-mongoid', github: 'carrierwaveuploader/carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'mongoid-grid_fs',     github: 'ahoward/mongoid-grid_fs'
    gem 'character',           github: 'slate-studio/character'

Run bundle and run generators:

    bundle ; rails g mongoid:config ; rails g character:install

Start development server and open website in a browser.

## API

### (Character.Generic.DetailsView)[#]

These are blank methods that could be overriden to extend view functionality.

Example of usage: (character/posts/module.coffee)[#]

- @beforeRenderContent()
- @afterRenderContent()
- @beforeOnSave()
- @beforeFormSubmit(arr, $form, options)
- @afterFormSubmitSuccess(responseText, statusText, xhr, $form)
- @beforeOnClose()
- @afterOnClose()


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

### TODO

* replace blog posts with just posts
* auto save posts
* optimize image size for posts
* image uploading improvements, progressbar, on drop style
  http://tympanus.net/Development/ProgressButtonStyles/
* jump to edit after create new;
* forms: hide errors when update is succesful; as an option we can close the details view on save;
* hotkeys: character and editor;
* no page refresh on login;
* posterous posting options via email (https://posthaven.com/)