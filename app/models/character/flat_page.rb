class Character::FlatPage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :path

  field :template_name, default: 'default'
  field :template_content, type: Hash, default: {}

  def template_path
    "flat_pages/#{ template_name }"
  end
end