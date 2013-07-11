class FoundationSwitchInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input
    options = input_options

    # do not wrap items in tags
    options[:item_wrapper_tag] = false

    # setting custom labels if provided
    if options[:labels]
      collection = [false, true].zip(options[:labels])
    else
      collection = [[false, 'No'], [true, 'Yes']]
    end

    # internal helpers to worki with collection
    label_method = :last
    value_method = :first

    html = @builder.send("collection_radio_buttons",
      attribute_name, collection, value_method, label_method,
      options, input_html_options, &collection_block_for_nested_boolean_style
    )

    # wrap html into foundation layout

    "<div class='switch round'>#{ html }<span></span></div>"
  end

  protected

  # disable label input
  def label_input
    input
  end
end