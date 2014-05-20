# frontend assets
require 'compass-rails'
require 'font-awesome-rails'
require 'jquery-ui-rails'
require 'underscore-rails'
require 'marionette-rails'
require 'momentjs-rails'
require 'character_editor'
require 'rhythm'
require 'simple_form_scss'

# backend
require 'browserid-rails'
require 'simple_form'
require 'nested_form'
require 'kaminari'
require 'mongoid_slug'
require 'mongoid_search'
require 'meta_tags'
require 'mini_magick'
require 'mongoid/carrierwave_serialization_patch'

# character
require 'character/settings'
require 'character/instance'
require 'character/version'
require 'character/engine'
require 'character/routing'
require 'character/generators/install_generator'