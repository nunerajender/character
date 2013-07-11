class FoundationStringInput < SimpleForm::Inputs::StringInput
  def input
    unless string?
      input_html_classes.unshift("string")
      input_html_options[:type] ||= :text if html5?
    end

    html = @builder.text_field(attribute_name, input_html_options)

    options = input_options

    prefix_columns  = 0
    postfix_columns = 0

    if options[:prefix]
      prefix_label   = options[:prefix][:label]
      prefix_columns = options[:prefix][:columns] || 0
    end

    if options[:postfix]
      postfix_label   = options[:postfix][:label]
      postfix_columns = options[:postfix][:columns] || 0
    end

    input_columns = 12 - prefix_columns - postfix_columns

    prefix_html  = ""
    postfix_html = ""

    if prefix_label
      prefix_html = "<div class='small-#{prefix_columns} columns'>
                       <span class='prefix'>#{prefix_label}</span>
                     </div>"
    end

    if postfix_label
      postfix_html = "<div class='small-#{postfix_columns} columns'>
                        <span class='postfix'>#{postfix_label}</span>
                      </div>"
    end

    "<div class='row collapse'>#{prefix_html}<div class='small-#{input_columns} columns'>#{ html }</div>#{postfix_html}</div>".html_safe
  end
end