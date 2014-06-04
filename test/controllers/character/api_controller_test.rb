require 'test_helper'

class Character::ApiControllerTest < ActionController::TestCase
  # Called before every single test
  setup do
    @product = FactoryGirl.create(:product)
  end

  # Called after every single test
  teardown do
    DatabaseCleaner.clean
  end

  test "should get index" do
    get :index, model_slug: "Product"
    assert_response :success
    assert json_response.length > 0
  end

  test "should get scoped index" do
    FactoryGirl.create(:product, published: false)

    get :index, model_slug: "Product"
    assert_response :success
    assert_equal json_response.length, 2

    get :index, model_slug: "Product", where__published:"true"
    assert_response :success
    assert_equal json_response.length, 1
  end

  test "should get ordered index" do
    FactoryGirl.create(:product, title: "Shoes")
    FactoryGirl.create(:product, title: "Jacket")

    get :index, model_slug: "Product", o: "title"
    assert_response :success

    obj_1 = json_response.find{|obj| obj["title"] == "Jacket"}
    obj_2 = json_response.find{|obj| obj["title"] == "Shoes"}

    assert json_response.index(obj_1) < json_response.index(obj_2)
  end

  test "should show obect" do
    get :show, model_slug: "Product", id: @product.id
    assert_response :success
  end

  test "should get new" do
    get :new, model_slug: "Product"
    assert_response :success
  end

  test "should create obect" do
    assert_difference("Product.count") do
      post :create, model_slug: "Product", product: { title: "Hat" }
    end
    assert_equal json_response["title"], "Hat"
  end

  test "should not create if obect is not valid" do
    assert_no_difference("Product.count") do
      post :create, model_slug: "Product", product: { title: "Hat - Invalid attribute"}
    end
    assert_template @controller.form_template
    assert_not_nil assigns(:object)
  end

  test "should get edit" do
    get :edit, model_slug: "Product", id: @product
    assert_response :success
  end

  test "should update obect" do
    put :update, model_slug: "Product", id: @product, product: { title: "Jacket" }
    assert_equal json_response["title"], "Jacket"
  end

  test "should not update if obect is not valid" do
    put :update, model_slug: "Product", id: @product, product: { title: "Hat - Invalid attribute" }
    assert_template @controller.form_template
    assert_not_nil assigns(:object)
  end

  test "should destroy obect" do
    assert_difference('Product.count', -1) do
      delete :destroy, model_slug: "Product", id: @product
    end
    assert_equal @response.body, "null"
    assert_equal @response.status, 204
  end
end

