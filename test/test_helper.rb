require 'config/application'

require "rails/test_help"
require "minitest/rails"

require "database_cleaner"
DatabaseCleaner.strategy = :truncation

require "factory_girl"
FactoryGirl.find_definitions

class ActiveSupport::TestCase
  # Helper methods available in all tests

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end
