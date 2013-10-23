require 'test_helper'

class Character::RoutingTest < ActionDispatch::IntegrationTest
  test "the truth" do
    assert true
  end

  #
  # Routes for API
  #

  test "should root to index (api)" do
    assert_routing({ path: "/admin/Foo", method: "get" }, { controller: "character/api", action: "index", model_slug: "Foo"})
  end

  test "should root to show (api)" do
    assert_routing({ path: "/admin/Foo/1", method: "get" }, { controller: "character/api", action: "show", model_slug: "Foo", id: "1"})
  end

  test "should root to new (api)" do
    assert_routing({ path: "/admin/Foo/new", method: "get" }, { controller: "character/api", action: "new", model_slug: "Foo"})
  end

  test "should root to create (api)" do
    assert_routing({ path: "/admin/Foo", method: 'post' }, { controller: "character/api", action: "create", model_slug: "Foo"})
  end

  test "should root to edit (api)" do
    assert_routing({ path: "/admin/Foo/1/edit", method: 'get' }, { controller: "character/api", action: "edit", model_slug: "Foo", id: "1"})
  end

  test "should root to update (api)" do
    assert_routing({ path: "/admin/Foo/1", method: 'put' }, { controller: "character/api", action: "update", model_slug: "Foo", id: "1"})
  end

  test "should root to destroy (api)" do
    assert_routing({ path: "/admin/Foo/1", method: 'delete' }, { controller: "character/api", action: "destroy", model_slug: "Foo", id: "1"})
  end
end
