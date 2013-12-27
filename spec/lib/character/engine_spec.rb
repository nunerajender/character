require 'spec_helper'

describe Character::Engine do
  it "provides default admin instance" do
    Character.instances = nil
    expect(Character.instances).to be
    expect(Character.instances.keys.first).to eq("admin")
  end

  it "creates new instances" do
    Character.instance 'producers' do |instance|
      instance.user_model = 'Producer'
    end
    expect(Character.instances.keys.index("producers")).to be
  end

  # it "is configurable" do
  #   Character.configure do |config|
  #     config.title = 'Test Title'
  #   end
  #   expect(Character.title).to eq("Test Title")
  # end
end