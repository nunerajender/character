class Character::Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::DateHelper

  # attributes
  field :title
  field :path # no leading '/', please
  field :template_name, default: 'default'
  field :template_content, type: Hash,  default: {}
  field :_position,        type: Float, default: ->{ (Character::Page.all.first.try(:_position) || 1000) + 10 }

  # scopes
  default_scope -> { order_by(_position: :desc) }

  # indexes
  index({ path: 1 })

  # helpers
  def template_path
    "pages/#{ template_name }"
  end

  def updated_ago
    "updated #{time_ago_in_words(updated_at)} ago"
  end
end