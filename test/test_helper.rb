require 'config/test_application'

require "rails/test_help"
require "minitest/rails"

require "database_cleaner"
require "factory_girl"

Dir[Rails.root + "test/factories/*.rb"].each {|file| require file }

class ActiveSupport::TestCase
  # Add helper methods to be used by all tests here...
end
