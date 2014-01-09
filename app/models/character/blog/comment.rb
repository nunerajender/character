# encoding: UTF-8
class Character::Blog::Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text
  field :name
  field :website
  field :published, type: Boolean, default: false

  belongs_to :post, class_name: "Character::Blog::Post"

  scope :published,    where(published: true)
  scope :latest_first, order_by(created_at: :desc)

  def website_valid?
    uri = URI.parse(website)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end

  def website_url
    @website_url ||= website_valid? ? website : ''
  end
end