class Character::Blog::FeaturedImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/character/blog/featured_images/#{ model.id }"
  end

  version :chr_list_thumbnail do
    process resize_to_fill: [56, 56]
  end

  version :cover do
    process resize_to_fill: [1000, 420]
  end

  version :opengraph do
    process resize_to_fill: [150, 150]
  end
end