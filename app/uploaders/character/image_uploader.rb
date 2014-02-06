class Character::ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/character/images/#{ model.id }"
  end
end