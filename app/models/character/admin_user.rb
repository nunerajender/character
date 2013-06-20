class Character::AdminUser
  # TODO: revise this model while switch to devise

  include Mongoid::Document
  include Mongoid::Timestamps
  include Character::Admin
  
  field :name
  field :email

  # Relations
  has_many :posts, :class_name => 'Character::Post'


  def self.find_by_email(email)
    Character::AdminUser.where(email:email).first()
  end

  def avatar_url(size)
    hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar/#{ hash}?s=#{ size }&d=mm"
  end

  def admin_thumb_url
    avatar_url(56)
  end

  def self.admin_title
    "Admins"
  end
end
