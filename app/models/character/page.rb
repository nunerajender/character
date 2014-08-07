class Character::Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include UpdatedAgo
  include Orderable
  include Hideable

  # attributes
  field :title
  field :seo_title
  field :seo_description
  field :path
  field :template_name,                     default: 'redactor'
  field :template_content,  type: Hash,     default: {}

  # indexes
  index({ path: 1 })

  # helpers
  def template_path
    "pages/#{ template_name }"
  end
end
