module FlatPageHelper
  def inline_editable(template_content_key, placeholder='', default_content='')
    if @object
      if placeholder.empty?
        placeholder = template_content_key + '...'
      end

      flat_page = @object
      class_underscore = @object.class.name.underscore.gsub('/', '_')

      content = flat_page.template_content[template_content_key]
      content ||= default_content

      if @form_action_url
        """<span class='character-editor'
                 data-input-name='#{class_underscore}[template_content][#{ template_content_key }]'
                 data-options=\"placeholder:'#{ placeholder }';disableReturn:true;disableToolbar:true;\"
           >#{ content }</span>""".html_safe
      else
        content.html_safe
      end
    end
  end

  def editable(template_content_key, placeholder='', default_content='')
    if @object
      if placeholder.empty?
        placeholder = template_content_key + '...'
      end

      flat_page  = @object
      class_underscore = @object.class.name.underscore.gsub('/', '_')

      content = flat_page.template_content[template_content_key]
      content ||= default_content

      if @form_action_url
        """<div class='character-editor'
                data-input-name='#{class_underscore}[template_content][#{ template_content_key }]'
                data-options=\"placeholder:'#{ placeholder }';targetBlanks:true;\"
           >#{ content }</div>""".html_safe
      else
        content.html_safe
      end
    end
  end
end