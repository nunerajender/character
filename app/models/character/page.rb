class Character::Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include UpdatedAgo
  include Orderable

  # attributes
  field :title
  field :path
  field :template_name,                     default: 'redactor'
  field :template_content,  type: Hash,     default: {}
  field :hidden,            type: Boolean,  default: false

  # indexes
  index({ path: 1 })

  # scopes
  scope :public,  -> { where(hidden: false) }
  scope :private, -> { where(hidden: true)  }

  # helpers
  def template_path
    "pages/#{ template_name }"
  end
end