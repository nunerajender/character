# Character

**Character** is an administration application build with **Backbone.js** and **Foundation** using **Rails** / **CoffeeScript** / **SASS**.

## What's inside?


## Setup

Start a new Rails project: ```$ rails new appname -T -O```.


#### Gems

Update your ```Gemfile``` by adding these gems:

    # Mongoid
    gem 'bson_ext'
    gem 'mongoid'

    # Character
    gem 'rmagick'
    gem 'character', git: 'git://github.com/alexkravets/character-rails.git', branch: 'admin'

Make sure that in the begining of ```Gemfile``` you have ruby version line: ```ruby '1.9.3'``` - this is **required** for **mongoid v3** gem.


#### Mongoid

Generate mongoid configuration with: ```rails generate mongoid:config``` command, add **production** configuration for heroku:

    production:
      sessions:
        default:
          uri: <%= ENV['MONGOLAB_URI'] %>


#### Assets

Generate admin assets to be used in the new projects:

...

Add these assets to the ```config/environment/production.rb``` file:

    config.assets.precompile += %w(admin.js admin.css foundation/modernizr.foundation.js)






#### S3

Configure heroku environment for assets uploading and media files:

    heroku config:set FOG_DIRECTORY='' FOG_MEDIA_DIRECTORY='' FOG_PROVIDER='AWS'
    heroku config:set AWS_ACCESS_KEY_ID='' AWS_SECRET_ACCESS_KEY=''

Create (edit) ```config/initializers/carrierwave.rb``` like this:

    require 'carrierwave/processing/mime_types'

    CarrierWave.configure do |config|
      config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')
      config.storage = :fog

      config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
      }

      case Rails.env.to_sym
      when :development
        config.storage = :file
      when :production
        config.fog_directory  = ENV['FOG_MEDIA_DIRECTORY']
        config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
      end
    end





#### Routes

Add pages, blog and admin app routes to the ```config/routes.rb``` file:

    mount_character_admin()
    mount_character_pages()
    mount_character_blog_at('/blog')

Remove ```public/index.html``` file.


Add meta tags support to apps main layout (```views/layouts/application.html.erb```): 

    <head>
      ...
      <%= display_meta_tags site:        ENV['WEBSITE_NAME'],
                            description: ENV['WEBSITE_DESCRIPTION'],
                            keywords:    ENV['WEBSITE_KEYWORDS'],
                            canonical:   "http://#{ ENV['WEBSITE_URL'] }",
                            # https://developers.facebook.com/docs/technical-guides/opengraph/built-in-objects/#website
                            open_graph:  { type:        'website',
                                           title:       ENV['WEBSITE_NAME'],
                                           description: ENV['WEBSITE_DESCRIPTION'],
                                           url:         "http://#{ ENV['WEBSITE_URL'] }"
                                           # app_id: '' <-- if required
                                           # image:  '' <-- if required
                                         } %>
      ...
    </head>

Add first admin user via console: ```Character::AdminUser.create! email:'santyor@gmail.com'``` 









## How to?

### Images

## Credentials


## TODO

**Styles:**
 - Image uploader style for markdown editor

**Features:**
 - fix fixed panels to be autosized without js
 - check a bunch of editors from: https://github.com/dybskiy/redactor-js/issues/2
 - redo blog/pages editor css layout similar to http://dillinger.io/
 - Make RSS pass validation: http://webdesign.about.com/od/validators/l/bl_validation.htm#rssvalidator
 - Select image size (checkbox if scaled version should be used) when uploading image (redactor/markdown)
 - Set page _position when creating new
 - Remove page function
 - Moving page element
 - Add filters/categories for the blog
 - Filter which converts local images paths to S3 hosted
 - Integrate fitvids into markdown editor


