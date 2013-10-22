require 'test_helper'

class Character::ApiControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @foo = FactoryGirl.create(:foo)
  end

  teardown do
    DatabaseCleaner.clean
  end


  #
  # Actions
  #

  # test "should get index" do
  #   get :index, model_slug: "Foo"
  #   assert_response :success
  #   assert_not_nil assigns(:dogs)
  # end

  test "should show foo" do
    get :show, model_slug: "Foo", id: @foo.id
    assert_response :success
  end

  test "should get new" do
    get :new, model_slug: "Foo"
    assert_response :success
  end

  test "should create foo" do
    assert_difference("Foo.count") do
      post :create, model_slug: "Foo", foo: { name: "Test" }
    end
    assert_equal json_response["name"], "Test"
  end

  # test "should not create if foo is not valid" do
  #   assert_no_difference("Foo.count") do
  #     post :create, model_slug: "Foo", foo: { name: "Test", age: "abc" }
  #   end
  #   assert_template @controller.form_template
  # end

  test "should get edit" do
    get :edit, model_slug: "Foo", id: @foo
    assert_response :success
  end

  test "should update foo" do
    put :update, model_slug: "Foo", id: @foo, foo: { name: "Test 2" }
    assert_equal json_response["name"], "Test 2"
  end

  test "should destroy foo" do
    assert_difference('Foo.count', -1) do
      delete :destroy, model_slug: "Foo", id: @foo
    end
    assert_equal @response.body, "ok"
  end


  #
  # Routes
  #

  test "index route" do
    assert_routing({ path: "/admin/Foo", method: "get" }, { controller: "character/api", action: "index", model_slug: "Foo"})
  end

  test "show route" do
    assert_routing({ path: "/admin/Foo/1", method: "get" }, { controller: "character/api", action: "show", model_slug: "Foo", id: "1"})
  end

  test "new route" do
    assert_routing({ path: "/admin/Foo/new", method: "get" }, { controller: "character/api", action: "new", model_slug: "Foo"})
  end

  test "create route" do
    assert_routing({ path: "/admin/Foo", method: 'post' }, { controller: "character/api", action: "create", model_slug: "Foo"})
  end

  test "edit route" do
    assert_routing({ path: "/admin/Foo/1/edit", method: 'get' }, { controller: "character/api", action: "edit", model_slug: "Foo", id: "1"})
  end

  test "update route" do
    assert_routing({ path: "/admin/Foo/1", method: 'put' }, { controller: "character/api", action: "update", model_slug: "Foo", id: "1"})
  end

  test "destroy route" do
    assert_routing({ path: "/admin/Foo/1", method: 'delete' }, { controller: "character/api", action: "destroy", model_slug: "Foo", id: "1"})
  end
end

