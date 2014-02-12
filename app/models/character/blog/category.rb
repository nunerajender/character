# encoding: UTF-8
class Character::Blog::Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic # required to remove users using _delete field

  # attributes
  field :title
  field :_position, type: Float, default: 0.0

  # relations
  has_many :posts, class_name: 'Character::Blog::Post'

  # slugs
  slug :title, history: true

  # scopes
  default_scope -> { order_by(_position: :desc) }

  # indexes
  index({ slug: 1 })
  index({ _position: -1 })
end