module Settings
  mattr_accessor :settings_file
  @@settings_file = "config/settings.yml"

  def self.settings_from_yml
    unless @settings_from_yml
      settings_file = ::Rails.root.join(@@settings_file)
      @settings_from_yml = {}

      if File.exists?(settings_file)
        data = YAML::load(ERB.new(IO.read(settings_file)).result)
        @settings_from_yml = data if data
      end
    end
    @settings_from_yml
  end

  def self.group(group_name)
    group = {}
    settings_from_yml[group_name].each do |name, attrs|
      group[name] = Variable.new(group_name, name, attrs)
    end
    group
  end

  def self.stored_variables
    @stored_variables ||= Character::Settings::Variable.all
    Character::Settings::Variable.all
  end

  class Variable
    attr_accessor :type, :description, :default_value, :stored_object

    def initialize(group, name, attrs)
      @type            = attrs['type']          || 'string'
      @description     = attrs['description']   || ''
      @default_value   = attrs['default_value'] || ''
      @stored_object   = Character::Settings::Variable.find_or_create_by(name: name, group: group)
    end

    def value
      value = @stored_object.value || @default_value

      if @type == 'file'
        if @stored_object.has_file_uploaded?
          # return uploaded file
          return @stored_object.file.to_s
        elsif value.include? '//'
          # return direct link to file
          return value
        elsif value.empty?
          # return empty string
          return value
        else
          # return rails asset
          return ActionController::Base.helpers.asset_path(value)
        end
      else
        return value
      end
    end
  end
end