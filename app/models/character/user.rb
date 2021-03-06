class Character::User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic # required to remove users using _delete field

  field     :email
  validates :email,
            presence:   true,
            uniqueness: true#,
            #format:     { :with => /^([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i }

  index({ email: 1 }, { unique: true })

  # Methods -----------------------------------------------

  def self.find_by_email(email)
    where(email:email).first()
  end

  def gravatar_url(size)
    hash = Digest::MD5.hexdigest(email)
    # http://robohash.org
    "https://robohash.org/bgset_bg2/#{hash}?gravatar=hashed&size=#{size}x#{size}"
  end

  def chr_thumbnail_url
    gravatar_url(56)
  end
end