# encoding: UTF-8
class Character::PostCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic # required to remove users using _delete field
  include Orderable

  # attributes
  field :title

  # relations
  has_many :posts, class_name: 'Character::Post'

  # slugs
  slug :title, history: true

  # indexes
  index({ slug: 1 })
  index({ _position: -1 })
end