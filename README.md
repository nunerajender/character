# Character


## Setup new project (Rails 4)

    rails new ProjectName -T -O

Add gems to the ```Gemfile```:

    # ORM
    gem 'mongoid', github: 'mongoid/mongoid'
    gem 'bson_ext'

    # File uploader
    gem 'carrierwave-mongoid', github: 'carrierwaveuploader/carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'mongoid-grid_fs',     github: 'ahoward/mongoid-grid_fs'

    # Character
    gem 'character', github: 'slate-studio/character'

Run bundle and run generators:

    bundle ; rails g mongoid:config ; rails g character:install

Start development server and open website in a browser.


### TODO

* images app, which is integrated with blog and editor;
  http://5minutenpause.com/blog/2013/09/04/multiple-file-upload-with-jquery-rails-4-and-paperclip/
  http://blueimp.github.io/jQuery-File-Upload/basic-plus.html
  https://github.com/blueimp/jQuery-File-Upload
  http://tympanus.net/Development/ProgressButtonStyles/
  http://tympanus.net/Development/FullscreenOverlayStyles/index5.html
* image upload spin;
* hover effect while image drop;
* jump to edit after create new;
* forms: hide errors when update is succesful; as an option we can close the details view on save;
* hotkeys: character and editor;
* no page refresh on login;
* posterous posting options via email (https://posthaven.com/);


### Tools

* On item actions support: http://github.hubspot.com/tether/docs/welcome/


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

## API

### Character.Generic.DetailsView

- @beforeRenderContent()
- @afterRenderContent()
- @beforeOnSave()
- @beforeFormSubmit(arr, $form, options)
- @afterFormSubmitSuccess(responseText, statusText, xhr, $form)
- @beforeOnClose()
- @afterOnClose()
