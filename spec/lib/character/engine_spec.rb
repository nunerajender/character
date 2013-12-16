require 'spec_helper'

describe Character::Engine do
  it "provides default admin namespace" do
    Character.namespaces = nil
    expect(Character.namespaces).to be
    expect(Character.namespaces.keys.first).to eq("admin")
  end

  it "creates new namespaces" do
    Character.namespace 'producers' do |namespace|
      namespace.user_model = 'Producer'
    end
    expect(Character.namespaces.keys.index("producers")).to be
  end

  # it "is configurable" do
  #   Character.configure do |config|
  #     config.title = 'Test Title'
  #   end
  #   expect(Character.title).to eq("Test Title")
  # end
end