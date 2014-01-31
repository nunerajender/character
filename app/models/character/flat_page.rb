class Character::FlatPage
  include Mongoid::Document
  include Mongoid::Timestamps

  # attributes
  field :title
  field :path
  field :template_name, default: 'default'
  field :template_content, type: Hash, default: {}
  field :_position, type: Float, default: 0.0

  # scopes
  default_scope -> { order_by(_position: :desc) }

  # indexes
  index({ path: 1 })

  # helpers
  def template_path
    "flat_pages/#{ template_name }"
  end
end