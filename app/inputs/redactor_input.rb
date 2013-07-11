class RedactorInput < SimpleForm::Inputs::TextInput
  def input
    @builder.text_area(attribute_name, input_html_options)
  end
end