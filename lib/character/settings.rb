module Settings
  # TODO: this module should be refactored
  # - now we ping db to get every single value
  # - need to cache all values in one request, so ping db once per request

  mattr_accessor :settings_file
  @@settings_file = "config/settings.yml"

  def self.value(key)
    group_name, value_name = key.split('::')
    groups[group_name][value_name].value
  end

  def self.group(group_name)
    groups[group_name]
  end

  def self.groups
    unless @groups
      @groups = {}
      settings_from_yml.keys.each do |group_name|
        @groups[group_name] = settings_from_yml[group_name].map do |name, attrs|
          [ name, Variable.new(group_name, name, attrs) ]
        end.to_h
      end
    end
    @groups
  end

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

  def self.stored_variables
    @stored_variables ||= Character::Settings::Variable.all
    Character::Settings::Variable.all
  end

  class Variable
    attr_accessor :group,
                  :name,
                  :type,
                  :description,
                  :default_value

    def initialize(group, name, attrs)
      @group         = group
      @name          = name
      @type          = attrs['type']          || 'string'
      @description   = attrs['description']   || ''
      @default_value = attrs['default_value'] || ''
    end

    def stored_object
      Character::Settings::Variable.find_or_create_by(name: @name, group: @group)
    end

    def value
      object = stored_object
      value  = object.value || @default_value

      if @type == 'file'
        if object.has_file_uploaded?
          # return uploaded file
          return object.file.to_s
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

      elsif @type == 'integer'
        return value.to_i

      elsif @type == 'float'
        return value.to_f

      else # string
        return value
      end
    end
  end
end