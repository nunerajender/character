require 'config/application'

require "rails/test_help"
require "minitest/rails"

require "database_cleaner"
DatabaseCleaner.strategy = :truncation

require "factory_girl"
FactoryGirl.find_definitions

require "minitest/reporters"
Minitest::Reporters.use!

# Requires supporting ruby files with custom matchers and macros, etc,
# in test/support/ and its subdirectories.
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  # Helper methods available in all tests

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end
