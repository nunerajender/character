class Character::Image
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :image, Character::ImageUploader
end