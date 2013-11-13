require 'test_helper'

class Character::EngineTest < ActiveSupport::TestCase
  test "should provide default admin namespace" do
    Character.namespaces = nil
    assert_not_nil Character.namespaces
    assert_equal "admin", Character.namespaces.keys.first
  end

  test "should create new namespaces" do
    Character.namespace 'producers' do |namespace|
      namespace.user_model             = 'Producer'
      namespace.no_auth_on_development = true
    end
    assert_not_nil Character.namespaces.keys.index("producers")
  end

  test "should be configurable" do
    Character.configure do |config|
      config.title = 'Test Title'
    end
    assert_equal "Test Title", Character.title
  end
end