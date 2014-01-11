module Character::TemplatesConcern
  extend ActiveSupport::Concern

  def form_template
    @form_template ||= begin
      template_folder = model_class.name.underscore.to_s.pluralize
      template_folder.gsub!('character/', '')

      generic_template_folder    = "character/#{ template_folder }"
      instance_template_folder = "character/#{ character_instance.name }/#{ template_folder }"

      if    template_exists?("form", instance_template_folder, false)
        "#{ instance_template_folder }/form"
      elsif template_exists?("form", generic_template_folder, false)
        "#{ generic_template_folder }/form"
      else
        @generic_form_fields = model_class.fields.keys - %w( _id _type created_at _position _keywords updated_at deleted_at )
        "character/generic_form"
      end
    end
  end

  def form_action_url(object)
    if object.persisted?
      "/#{ character_instance.name }/#{ model_slug }/#{ object.id }"
    else
      "/#{ character_instance.name }/#{ model_slug }"
    end
  end
end
