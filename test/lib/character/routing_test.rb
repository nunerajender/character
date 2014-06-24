require 'test_helper'

class Character::RoutingTest < ActionDispatch::IntegrationTest
  test "should have root for api:index" do
    assert_routing({ path: "/admin/Product", method: "get" }, { controller: "character/api", action: "index", model_slug: "Product"})
  end

  test "should have root for api:show" do
    assert_routing({ path: "/admin/Product/1", method: "get" }, { controller: "character/api", action: "show", model_slug: "Product", id: "1"})
  end

  test "should have root for api:new" do
    assert_routing({ path: "/admin/Product/new", method: "get" }, { controller: "character/api", action: "new", model_slug: "Product"})
  end

  test "should have root for api:create" do
    assert_routing({ path: "/admin/Product", method: 'post' }, { controller: "character/api", action: "create", model_slug: "Product"})
  end

  test "should have root for api:edit" do
    assert_routing({ path: "/admin/Product/1/edit", method: 'get' }, { controller: "character/api", action: "edit", model_slug: "Product", id: "1"})
  end

  test "should have root for api:update" do
    assert_routing({ path: "/admin/Product/1", method: 'put' }, { controller: "character/api", action: "patch", model_slug: "Product", id: "1"})
  end

  test "should have root for api:destroy" do
    assert_routing({ path: "/admin/Product/1", method: 'delete' }, { controller: "character/api", action: "destroy", model_slug: "Product", id: "1"})
  end
end
