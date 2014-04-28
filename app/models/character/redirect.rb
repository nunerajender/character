class Character::Redirect
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic # required to remove users using _delete field

  # attributes
  field :path
  field :destination
  field :type, type: Integer, default: 301

  TYPE_CHOICES = [ ["301", 301], ["302", 302] ].freeze

  # indexes
  index({ path: 1 })
end