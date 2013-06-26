class Character::AdminUser
  include Mongoid::Document
  include Mongoid::Timestamps
  include Character::Admin

  field :name


  #
  # Relations
  #

  # has_many :posts, :class_name => 'Character::Post'


  #
  # Devise
  #

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 # Since we are using Mongoid ORM, we need to explicitly define fields in the model.

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String


  #
  # Methods
  #

  def self.find_by_email(email)
    Character::AdminUser.where(email:email).first()
  end

  def avatar_url(size)
    hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar/#{ hash}?s=#{ size }&d=mm"
  end

  def character_thumb_url
    avatar_url(56)
  end

  def self.admin_title
    "Admins"
  end
end
