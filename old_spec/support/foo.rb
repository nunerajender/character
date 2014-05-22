class Foo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :published, type: Boolean, default: true

  validates :name, length: { maximum: 6 }
end