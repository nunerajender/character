class Character::ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/character/images/#{ model.id }"
  end

  # used for thumbnails in the list view
  version :chr_thumb_small do
    process resize_to_fill: [56, 56]
  end

  # used in gallery modal view
  version :chr_thumb do
    process resize_to_fill: [156, 156]
  end
end