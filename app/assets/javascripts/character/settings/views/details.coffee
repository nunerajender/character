

class @SettingsDetailsView extends Backbone.Marionette.Layout
  template: JST["character/settings/templates/details"]
 

  ui:
    title:              '#settings_module_title'
    content:            '#details_content'
    footer:             '#details_footer'


  events:
    'click #action_close':  'on_close'
    'click #action_new':    'add_new_item'
    'click .action_cancel': 'remove_new_item' 
    'click .action_delete': 'remove_item' 


  onRender: ->
    @ui.title.html @options.name


  on_close: (e) ->
    @close()


  add_action_for_new_item: ->
    @ui.title.after """ <span class='chr-actions'><a href='#' id='action_new'>New</a></span>"""


  update_content: (html) ->
    @ui.content.html(html)

    # if there is a new item template add new action to the header
    @ui.new_item_template = @ui.content.find('#new_item_template')

    if @ui.new_item_template.length > 0
      @add_action_for_new_item()

    @ui.form = @ui.content.find('form')
    if @ui.form
      
      # This code is repeated in the generic app so probably should
      # be abstracted into separate module.

      # use foundation custom forms
      @ui.form.addClass('custom')

      # this is fix for foundation dates layout
      simple_form.set_foundation_date_layout()

      # foundation plugins
      @ui.content.foundation('section', 'resize')
      @ui.content.foundation('forms', 'assemble')

      @ui.submit_btn = @ui.content.find('.chr-btn-submit')

      @ui.form.ajaxForm
        beforeSubmit: (arr, $form, options) =>
          # dates fix
          _.each simple_form.get_date_values(arr), (el) -> arr.push el

          # disable button
          @ui.submit_btn.addClass 'disabled'

          return true
        
        success: (response) =>
          # enable button
          @ui.submit_btn.removeClass 'disabled'

      # this allows to attach plugins when form is rendered
      # specific to all settings forms
      $(document).trigger "character.settings.form.rendered", [ @el ]

      # this allows to attach plugins when form is rendered
      # specific to character settings module
      # $(document).trigger "character.settings.#{ @scope() }.form.rendered", [ @el ]


  add_new_item: (e) ->
    html   = @ui.new_item_template.html()

    new_id = new Date().getTime()
    html   = html.replace(/objects\[\]\[\]/g, "objects[][#{ new_id }]")
    html   = """<div class='settings_new_item'>#{ html }</div>"""

    @ui.new_item_template.before html
    e.preventDefault()


  remove_new_item: (e) ->
    $(e.currentTarget).closest('.settings_new_item').remove()
    e.preventDefault()


  remove_item: (e) ->
    item_cls = $(e.currentTarget).attr('data-item-class')
    
    if item_cls
      item = $(e.currentTarget).closest(".#{ item_cls }")
      
      destroy_field = _.find item.find("input[type=hidden]"), (f) ->
        name = $(f).attr 'name'
        _(name).endsWith '[_destroy]'
      
      $(destroy_field).attr('value', 'true')
      item.replaceWith(destroy_field)
    
    e.preventDefault()





