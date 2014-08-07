# encoding: UTF-8
class Character::Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Search
  include UpdatedAgo
  include Hideable

  # attributes
  field :title,     default: ''
  field :subtitle,  default: ''
  field :body_html, default: ''
  field :seo_title
  field :seo_description

  field :featured_image, type: Hash, default: { 'url' => '' }
  field :published_at,   type: DateTime, default: -> { DateTime.now }

  # relations
  belongs_to :category, class_name: "Character::PostCategory"
  belongs_to :author,   class_name: "Character::PostAuthor"

  # slugs and search
  slug      :title, history: true
  search_in :title, :body_html, :category => :title

  # scopes
  default_scope     -> { order_by(published_at: :desc) }
  scope :published, -> { where(hidden: false).lte(published_at: DateTime.now) }
  scope :scheduled, -> { where(hidden: false).gt(published_at: DateTime.now) }
  scope :drafts,    -> { where(hidden: true) }

  # indexes
  index({ slug: 1 })
  index({ hidden: 1, published_at: -1 })

  # helpers
  def featured_image_url
    featured_image ? featured_image['url'] : ''
  end
end
