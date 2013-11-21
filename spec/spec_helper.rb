require 'config/application'

require 'rspec/rails'
require 'rspec/autorun'

require "database_cleaner"
DatabaseCleaner.strategy = :truncation

require "factory_girl"
FactoryGirl.find_definitions

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

# class ActiveSupport::TestCase
#   # Helper methods available in all tests

#   def json_response
#     ActiveSupport::JSON.decode @response.body
#   end
# end