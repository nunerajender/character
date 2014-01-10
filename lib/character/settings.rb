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
    attr_accessor :type, :description, :default_value, :stored_value, :value

    def initialize(group, name, attrs)
      @type          = attrs['type']          || 'string'
      @description   = attrs['description']   || ''
      @default_value = attrs['default_value'] || ''
      @stored_value  = nil
      @value ||= @stored_value || @default_value || ''
    end
  end
end