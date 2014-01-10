class Character::Settings::FileUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/character/settings/files/#{ model.id }"
  end
end