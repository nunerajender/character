# encoding: UTF-8
class Character::Settings::Variable
  include Mongoid::Document
  include Mongoid::Timestamps

   # attributes
  field :group
  field :name
  field :value

  # uploaders
  mount_uploader :file, Character::Settings::FileUploader

  # helpers
  def has_file_uploaded?
    return false if file.to_s.empty?
    return false if file.to_s.end_with?('_old_')
    return true
  end
end