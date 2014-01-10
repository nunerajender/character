# encoding: UTF-8
class Character::Settings::Variable
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
end