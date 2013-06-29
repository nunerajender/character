class Character::AdminUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :email

  # Methods -----------------------------------------------

  def self.find_by_email(email)
    Character::AdminUser.where(email:email).first()
  end

  def gravatar_url(size)
    hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar/#{ hash}?s=#{ size }&d=mm"
  end

  def character_thumb_url
    gravatar_url(56)
  end
end
