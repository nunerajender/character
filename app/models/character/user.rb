class Character::User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email

  validates_presence_of :email
  validates_uniqueness_of :email

  index({ email: 1 }, { unique: true })

  # Methods -----------------------------------------------

  def self.find_by_email(email)
    where(email:email).first()
  end

  def gravatar_url(size)
    hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar/#{ hash }?s=#{ size }&d=mm"
  end

  def chr_thumbnail_url
    gravatar_url(56)
  end
end