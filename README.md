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

* check list pagination
* no page refresh on login
* hotkeys


### Tools

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
* Blog post layout templates: http://adobe-webplatform.github.io/css-regions-polyfill/
* On item actions support: http://github.hubspot.com/tether/docs/welcome/
* Might be used for subscription thing: http://andyatkinson.com/projects/promoSlide