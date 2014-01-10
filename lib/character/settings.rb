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
      # support for rails assets
      if @type == 'file' and not value.empty? and not value.include? '//'
        return ActionController::Base.helpers.asset_path(value)
      else
        return value
      end
    end
  end
end