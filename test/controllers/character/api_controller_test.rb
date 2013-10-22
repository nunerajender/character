require 'test_helper'

class Character::ApiControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
  end

  teardown do
    DatabaseCleaner.clean
  end


  #
  # Actions
  #

  test "show action" do
    foo = FactoryGirl.create(:foo)
    get :show, { model_slug: 'Foo', id: foo.id }
    assert_response :success
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:dogs)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create dog" do
  #   assert_difference('Dog.count') do
  #     post :create, dog: { age: @dog.age, name: @dog.name }
  #   end

  #   assert_redirected_to dog_path(assigns(:dog))
  # end

  # test "should show dog" do
  #   get :show, id: @dog
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @dog
  #   assert_response :success
  # end

  # test "should update dog" do
  #   patch :update, id: @dog, dog: { age: @dog.age, name: @dog.name }
  #   assert_redirected_to dog_path(assigns(:dog))
  # end

  # test "should destroy dog" do
  #   assert_difference('Dog.count', -1) do
  #     delete :destroy, id: @dog
  #   end

  #   assert_redirected_to dogs_path
  # end


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

