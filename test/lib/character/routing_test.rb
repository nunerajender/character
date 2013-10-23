require 'test_helper'

class Character::RoutingTest < ActionDispatch::IntegrationTest
  test "the truth" do
    assert true
  end

  test "api should have root for index" do
    assert_routing({ path: "/admin/Foo", method: "get" }, { controller: "character/api", action: "index", model_slug: "Foo"})
  end

  test "api should have root for show" do
    assert_routing({ path: "/admin/Foo/1", method: "get" }, { controller: "character/api", action: "show", model_slug: "Foo", id: "1"})
  end

  test "api should have root for new" do
    assert_routing({ path: "/admin/Foo/new", method: "get" }, { controller: "character/api", action: "new", model_slug: "Foo"})
  end

  test "api should have root for create" do
    assert_routing({ path: "/admin/Foo", method: 'post' }, { controller: "character/api", action: "create", model_slug: "Foo"})
  end

  test "api should have root for edit" do
    assert_routing({ path: "/admin/Foo/1/edit", method: 'get' }, { controller: "character/api", action: "edit", model_slug: "Foo", id: "1"})
  end

  test "api should have root for update" do
    assert_routing({ path: "/admin/Foo/1", method: 'put' }, { controller: "character/api", action: "update", model_slug: "Foo", id: "1"})
  end

  test "api should have root for destroy" do
    assert_routing({ path: "/admin/Foo/1", method: 'delete' }, { controller: "character/api", action: "destroy", model_slug: "Foo", id: "1"})
  end
end
