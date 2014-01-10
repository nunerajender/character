# encoding: UTF-8
class Character::Settings::Variable
  include Mongoid::Document
  include Mongoid::Timestamps

  field :group
  field :name
  field :value

  mount_uploader :file, Character::Settings::FileUploader
end