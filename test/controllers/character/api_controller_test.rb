require 'test_helper'

class Character::ApiControllerTest < ActionController::TestCase
  # Called before every single test
  setup do
    @foo = FactoryGirl.create(:foo)
  end

  # Called after every single test
  teardown do
    DatabaseCleaner.clean
  end

  test "should get index" do
    get :index, model_slug: "Foo"
    assert_response :success
    assert json_response.length > 0
  end

  test "should get scoped index" do
    FactoryGirl.create(:foo, published: false)

    get :index, model_slug: "Foo"
    assert_response :success
    assert_equal json_response.length, 2

    get :index, model_slug: "Foo", where__published:"true"
    assert_response :success
    assert_equal json_response.length, 1
  end

  test "should get ordered index" do
    FactoryGirl.create(:foo, name: "Test 3")
    FactoryGirl.create(:foo, name: "Test 2")

    get :index, model_slug: "Foo", o: "name"
    assert_response :success

    obj_1 = json_response.find{|obj| obj["name"] == "Test 2"}
    obj_2 = json_response.find{|obj| obj["name"] == "Test 3"}

    assert json_response.index(obj_1) < json_response.index(obj_2)
  end

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

  test "should not create if foo is not valid" do
    assert_no_difference("Foo.count") do
      post :create, model_slug: "Foo", foo: { name: "Test - Invalid attribute"}
    end
    assert_template @controller.form_template
    assert_not_nil assigns(:object)
  end

  test "should get edit" do
    get :edit, model_slug: "Foo", id: @foo
    assert_response :success
  end

  test "should update foo" do
    put :update, model_slug: "Foo", id: @foo, foo: { name: "Test 2" }
    assert_equal json_response["name"], "Test 2"
  end

  test "should not update if foo is not valid" do
    put :update, model_slug: "Foo", id: @foo, foo: { name: "Test - Invalid attribute" }
    assert_template @controller.form_template
    assert_not_nil assigns(:object)
  end

  test "should destroy foo" do
    assert_difference('Foo.count', -1) do
      delete :destroy, model_slug: "Foo", id: @foo
    end
    assert_equal @response.body, "ok"
  end
end

