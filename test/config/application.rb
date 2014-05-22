# Initialize a dummy application that is required to test
# the gem that supplies some behavior to another rails application

ENV["RAILS_ENV"] = "test"


#
# Rails
#


# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Workaround
require 'jquery/rails'

# Define the application and configuration
module RbConfig
  class Application < ::Rails::Application
    config.active_support.deprecation = :stderr
  end
end

# Initialize the application
RbConfig::Application.initialize!


#
# Mongoid
#

require "mongoid"

path_to_mongoid_config = File.join(File.dirname(__FILE__), "mongoid.yml")
Mongoid.load!(path_to_mongoid_config)


#
# Kaminari
#

require "kaminari"
Kaminari::Hooks.init


#
# Character
#

require "character"

RbConfig::Application.routes.draw do
  mount_character_instance
end