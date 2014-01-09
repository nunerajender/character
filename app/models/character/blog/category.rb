# encoding: UTF-8
class Character::Blog::Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title
  slug  :title

  field :_position, type: Float, default: 0.0

  has_many :posts, class_name: 'Character::Blog::Post'

  default_scope order_by(_position: :desc)

  index({ slug: 1 })
  index({ _position: -1 })
end