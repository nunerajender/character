require "spec_helper"

describe "API routing", :type => :routing do
  it "routes /admin/Foo to api#index" do
    expect(get: "/admin/Foo").to route_to(controller: "character/api", action: "index", model_slug: "Foo")
  end

  it "routes /admin/Foo/1 to api#show" do
    expect(get: "/admin/Foo/1").to route_to(controller: "character/api", action: "show", model_slug: "Foo", id: "1")
  end

  it "routes /admin/Foo/new to api#new" do
    expect(get: "/admin/Foo/new").to route_to(controller: "character/api", action: "new", model_slug: "Foo")
  end

  it "routes /admin/Foo to api#create" do
    expect(post: "/admin/Foo").to route_to(controller: "character/api", action: "create", model_slug: "Foo")
  end

  it "routes /admin/Foo/1/edit to api#edit" do
    expect(get: "/admin/Foo/1/edit").to route_to(controller: "character/api", action: "edit", model_slug: "Foo", id: "1")
  end

  it "routes /admin/Foo/1 to api#update" do
    expect(put: "/admin/Foo/1").to route_to(controller: "character/api", action: "update", model_slug: "Foo", id: "1")
  end

  it "routes /admin/Foo/1 to api#destroy" do
    expect(delete: "/admin/Foo/1").to route_to(controller: "character/api", action: "destroy", model_slug: "Foo", id: "1")
  end
end