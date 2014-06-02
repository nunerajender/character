# encoding: UTF-8
class Character::PostAuthor
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic # required to remove users using _delete field

  # attributes
  field :name
  field :title
  field :email
  field :url

  # relations
  has_many :posts, class_name: 'Character::Post'

  # slugs
  slug :name, history: true

  # indexes
  index({ slug: 1 })
end