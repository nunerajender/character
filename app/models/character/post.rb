# encoding: UTF-8
class Character::Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Search
  include ActionView::Helpers::DateHelper

  # attributes
  field :title
  field :subtitle,       default: ''
  field :featured_image, type: Hash, default: { 'url' => '', 'chr_thumbnail_url' => '' }
  field :body_html

  field :published,    type: Boolean, default: false
  field :published_at, type: Date

  # relations
  belongs_to :category, class_name: "Character::PostCategory"

  # slugs and search
  slug      :title, history: true
  search_in :title, :body_html, :category => :title

  # scopes
  default_scope     -> { order_by(published_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :drafts,    -> { where(published: false) }

  # indexes
  index({ slug: 1 })
  index({ published: 1, date: -1 })

  # helpers
  def featured_image_url
    featured_image ? featured_image['url'] : ''
  end

  def chr_featured_thumbnail_url
    featured_image ? featured_image['chr_thumbnail_url'] : ''
  end

  def updated_ago
    "updated #{time_ago_in_words(updated_at)} ago"
  end
end