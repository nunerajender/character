module TemplatesHelper
  # this helper provides way to redefine default templates to be
  # used for form-template based actions like new, edit, create, update
  def form_template
    set_form_attributes

    @form_template ||= begin
      template_folder = model_class.name.underscore.to_s.pluralize
      template_folder.gsub!('character/', '')

      generic_template_folder    = "character/#{ template_folder }"
      namespaced_template_folder = "character/#{ character_namespace.name }/#{ template_folder }"

      if    template_exists?("form", namespaced_template_folder, false)
        "#{ namespaced_template_folder }/form"
      elsif template_exists?("form", generic_template_folder, false)
        "#{ generic_template_folder }/form"
      else
        "character/generic_form"
      end
    end
  end

  def set_form_attributes
    # attributes required for generic form
    if @object.persisted?
      @form_action_url = "/#{ character_namespace.name }/#{ model_slug }/#{ @object.id }"
    else
      @form_action_url = "/#{ character_namespace.name }/#{ model_slug }"
    end

    @model_name = model_name

    @form_fields = model_class.fields.keys - %w( _id _type created_at _position _keywords updated_at deleted_at )
  end
end
