require 'test_helper'

class Character::EngineTest < ActiveSupport::TestCase
  # Called after every single test
  teardown do
    Character.instance_variable_set :@instances, {}
    Character.instance_variable_set :@custom_instance_name_used, nil
    Character.instance_variable_set :@default_instance_name_used, nil
  end

  test "should provide default admin instance" do
    Character.instances = nil
    assert_not_nil Character.instances
    assert_equal "admin", Character.instances.keys.first
  end

  test "should be configurable" do
    Character.configure do |config|
      config.title = 'Test Title'
    end
    assert_equal "Test Title", Character.title
  end

  test "should create new instances" do
    Character.configure do |config|
      config.instance 'author' do |instance|
        instance.user_model = 'Author'
      end
    end
    assert_not_nil Character.instances.keys.index("author")
  end

end