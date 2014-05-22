require 'test_helper'

class Character::EngineTest < ActiveSupport::TestCase
  test "should provide default admin instance" do
    Character.instances = nil
    assert_not_nil Character.instances
    assert_equal "admin", Character.instances.keys.first
  end


  # test "should create new instances" do
  #   Character.configure do |config|
  #     config.instance 'author' do |instance|
  #       instance.user_model = 'author'
  #       # instance.no_auth_on_development = true
  #     end
  #   end
  #   assert_not_nil Character.instances.keys.index("author")
  # end

  test "should be configurable" do
    Character.configure do |config|
      config.title = 'Test Title'
    end
    assert_equal "Test Title", Character.title
  end
end