class @CharacterAppController extends Marionette.Controller
  initialize: (@options) ->

    # Model api access url
    @api_url = @options.api || "/character/api/#{ @options.name }"
    
    # Collection setup
    @collection     = new CharacterGenericCollection()
    @collection.url = @api_url

    # Layout and views
    @layout = new CharacterAppIndexLayout()
    @collection_view = new CharacterAppIndexCollectionView({ collection: @collection })


  index: ->
    character.layout.main.show(@layout)
    @layout.body.show(@collection_view)

    @collection.fetch()
    
    # Header
    #@layout.header.show(@options.name)

    # Add pagination
    # Add saving last state
    # Add search
    # Add scopes
    # Add batch actions


  new: ->
    @index()
    @layout.ui.right_panel.show()


  edit: (id) ->
    @index()

    doc = @collection.get(id)

    @form_view = new CharacterAppIndexFormView(_.extend(@options, { model: doc }))
    @layout.right_panel.show(@form_view)

    url = "#{ @api_url }/#{ id }/edit"
    $.get url, (form_html) =>
      @form_view.ui.body.html(form_html)
      
      @form_view.ui.body.find('form').addClass('custom')
      @form_view.ui.body.foundation('section', 'resize')
      @form_view.ui.body.foundation('forms', 'assemble')



  remove: ->
    console.log "#{ @options.name } - remove action."



