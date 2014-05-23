# require 'spec_helper'

# describe Character::ApiController do
#   include Decode


#   after :each do
#     DatabaseCleaner.clean
#   end


#   describe "GET index" do
#     it "responds with all foos" do
#       foo = FactoryGirl.create(:foo)
#       get :index, model_slug: "Foo"
#       expect(response.status).to eq(200)
#       expect(decode_json(response.body)).to eq([decode_bson(foo)])
#     end

#     it "responds with the scoped foos" do
#       foo_1 = FactoryGirl.create(:foo)
#       foo_2 = FactoryGirl.create(:foo, published: false)
#       get :index, model_slug: "Foo", where__published: "true"
#       expect(response.status).to eq(200)
#       expect(decode_json(response.body)).to eq([decode_bson(foo_1)])
#     end

#     it "responds with the ordered foos" do
#       foo_1 = FactoryGirl.create(:foo, name: "Test 2")
#       foo_2 = FactoryGirl.create(:foo, name: "Test 1")
#       get :index, model_slug: "Foo", o: "name"
#       expect(response.status).to eq(200)
#       expect(decode_json(response.body)[0]["name"]).to eq("Test 1")
#       expect(decode_json(response.body)[1]["name"]).to eq("Test 2")
#     end
#   end


#   describe "GET show" do
#     it "responds with the requested foo" do
#       foo = FactoryGirl.create(:foo)
#       get :show, model_slug: "Foo", id: foo.id
#       expect(response.status).to eq(200)
#       expect(decode_json(response.body)).to eq(decode_bson(foo))
#     end
#   end


#   describe "GET new" do
#     it "renders form for a new foo" do
#       get :new, model_slug: "Foo"
#       expect(response.status).to eq(200)
#       expect(response).to render_template(controller.form_template)
#     end
#   end


#   describe "POST create" do
#     before :all do
#       @valid_attributes   = { model_slug: "Foo", foo: { name: "Test" } }
#       @invalid_attributes = { model_slug: "Foo", foo: { name: "Test - Invalid attribute" } }
#     end

#     describe "with valid params" do
#       it "creates a new Foo" do
#         expect{ post :create, @valid_attributes }.to change(Foo, :count).by(1)
#         expect(assigns(:object)).to be_a(Foo)
#         expect(assigns(:object)).to be_persisted
#       end

#       it "responds with a newly created foo" do
#         post :create, @valid_attributes
#         expect(response.status).to eq(200)
#         expect(decode_json(response.body)["name"]).to eq("Test")
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved foo as @object" do
#         Foo.any_instance.stub(:save).and_return(false)
#         post :create, @invalid_attributes
#         expect(assigns(:object)).to be_a_new(Foo)
#       end

#       it "re-renders form for the submitted foo" do
#         Foo.any_instance.stub(:save).and_return(false)
#         post :create, @invalid_attributes
#         expect(response).to render_template(controller.form_template)
#       end
#     end
#   end


#   describe "GET edit" do
#     it "renders form for the requested foo" do
#       foo = FactoryGirl.create(:foo)
#       get :edit, model_slug: "Foo", id: foo
#       expect(response.status).to eq(200)
#       expect(response).to render_template(controller.form_template)
#     end
#   end


#   describe "PUT update" do
#     before :each do
#       foo                 = FactoryGirl.create(:foo)
#       @valid_attributes   = { model_slug: "Foo", id: foo, foo: { name: "Test 2" } }
#       @invalid_attributes = { model_slug: "Foo", id: foo, foo: { name: "Test - Invalid attribute" } }
#     end

#     describe "with valid params" do
#       it "updates the requested foo" do
#         # Foo.any_instance.should_receive(:update).with({ name: "Test 2" })
#         put :update, @valid_attributes
#       end

#       it "responds with an updated foo" do
#         put :update, @valid_attributes
#         expect(response.status).to eq(200)
#         expect(decode_json(response.body)["name"]).to eq("Test 2")
#       end
#     end

#     describe "with invalid params" do
#       it "re-renders form for the submitted foo" do
#         Foo.any_instance.stub(:save).and_return(false)
#         put :update, @invalid_attributes
#         expect(response).to render_template(controller.form_template)
#       end
#     end
#   end


#   describe "DELETE destroy" do
#     it "destroys the requested foo" do
#       foo = FactoryGirl.create(:foo)
#       expect{ delete :destroy, model_slug: "Foo", id: foo }.to change(Foo, :count).by(-1)
#     end

#     it "renders \"ok\"" do
#       foo = FactoryGirl.create(:foo)
#       delete :destroy, model_slug: "Foo", id: foo
#       expect(response.body).to eq("ok")
#     end
#   end
# end

