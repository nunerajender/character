# encoding: UTF-8
class Character::Blog::Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Search

  field :title
  slug  :title

  field :tagline,      default: ''
  field :keywords,     default: ''
  field :category
  field :body_html
  field :published,    type: Boolean, default: false
  field :published_at, type: Date

  mount_uploader :featured_image, Character::Blog::FeaturedImageUploader

  belongs_to :category, class_name: "Character::Blog::Category"

  search_in :title, :tagline, :keywords, :body_html, :category => :title

  default_scope     -> { order_by(published_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :drafts,    -> { where(published: false) }

  index({ slug: 1 })
  index({ published: 1, date: -1 })

  def has_featured_image?
    not ( featured_image.to_s.ends_with?('_old_') or featured_image.to_s.empty? )
  end
end