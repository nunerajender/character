module FlatPageHelper
  def inline_editable(template_content_key, placeholder='', default_content='')
    if @object
      flat_page = @object

      content = flat_page.template_content[template_content_key]
      content ||= default_content

      if @form_action_url
        """<span class='chr-medium-editor-inline'
                 data-input-name='character_flat_page[template_content][#{ template_content_key }]'
                 data-placeholder='#{ placeholder }'>#{ content }</span>""".html_safe
      else
        content.html_safe
      end
    end
  end

  def editable(template_content_key, placeholder='', default_content='')
    if @object
      flat_page = @object

      content = flat_page.template_content[template_content_key]
      content ||= default_content

      if @form_action_url
        """<div class='chr-medium-editor'
                data-input-name='character_flat_page[template_content][#{ template_content_key }]'
                data-placeholder='#{ placeholder }'>#{ content }</div>""".html_safe
      else
        content.html_safe
      end
    end
  end
end