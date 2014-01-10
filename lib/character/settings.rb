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

  def self.groups
    unless @groups
      @groups = {}
      settings_from_yml.each do |group, variables|
        @groups[group] = {}
        variables.each { |name, attrs| @groups[group][name] = Variable.new(group, name, attrs) }
      end
    end
    @groups
  end

  def self.stored_variables
    @stored_variables ||= Character::Settings::Variable.all
  end

  class Variable
    attr_accessor :type, :description, :default_value, :stored_object

    def initialize(group, name, attrs)
      @type          = attrs['type']          || 'string'
      @description   = attrs['description']   || ''
      @default_value = attrs['default_value'] || ''
      @stored_object = Settings.stored_variables.select{ |o| o.group == group and o.name == name }.first
    end

    def value
      @value ||= begin
        value = @stored_object.try(:value) || @default_value

        # support for rails assets
        if @type == 'file' and not value.empty? and not value.include? '//'
          value = ActionController::Base.helpers.asset_path(value)
        end

        value
      end
    end
  end
end