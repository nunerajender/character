class Character::Image
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :image, Character::ImageUploader

  # scopes
  default_scope -> { order_by(created_at: :desc) }

  # indexes
  index({ created_at: 1, date: -1 })
end