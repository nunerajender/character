
@Character.Images ||= {}

@Character.Images.ListItemView = Backbone.Marionette.ItemView.extend
  tagName: 'li'

  template: (item) -> ''

  onRender: ->
    thumbUrl = @model.get('image').image.chr_thumb.url
    @$el.css 'background-image', "url(#{ thumbUrl })"
    @$el.attr 'data-id', @model.id

  events:
    'click': 'select'

  select: ->
    if not chr.images.options.multipleSelection
      @$el.parent().find('.selected').removeClass 'selected'

    @$el.toggleClass 'selected'


@Character.Images.ListView = Backbone.Marionette.CollectionView.extend
  tagName: 'ul'
  itemView: Character.Images.ListItemView


@Character.Images.Layout = Backbone.Marionette.Layout.extend
  id:        'chr_images'
  className: 'chr-images'

  template: -> """<div class='chr-images-dialog'>
                    <header class='chr-images-header'>
                      <span class='title'>Images</span>
                      <button id='chr_images_close' type='button' class='chr-images-close'><i class='chr-icon icon-close-alt'></i></button>
                    </header>
                    <section id=chr_images_grid class='chr-images-grid'></section>
                    <footer class='chr-images-footer'>
                      <button id=chr_images_insert class='chr-image-button-insert'>Insert</button>
                      <button id='chr_images_cancel'>Cancel</button>
                    </footer>
                  </div>"""

  regions:
    listContent: '#chr_images_grid'

  events:
    'click #chr_images_cancel': 'hide'
    'click #chr_images_close':  'hide'
    'click #chr_images_insert': 'insert'

  onRender: ->
    @list = new Character.Images.ListView({ collection: @options.collection })
    @listContent.show(@list)

  show: (@callback, @multipleSelection) ->
    @$el.addClass('open')
    @options.collection.fetchPage(1)

  hide: ->
    @$el.removeClass('open')

  insert: ->
    if @callback
      selectedModels = _.collect $('#chr_images_grid li.selected'), (el) =>
        id = $(el).attr('data-id')
        @options.collection.get(id)

      @callback(selectedModels)
    @hide()


# module initialization
chr.module 'images', (module) ->
  module.on 'start', ->
    @collection = new Character.Generic.Collection()
    @collection.options =
      collectionUrl: "#{ chr.options.url }/Character-Image"

    @layout = new Character.Images.Layout({ collection: @collection })
    $('#character').after(@layout.render().$el)

    # extend character api
    chr.commands.setHandler 'showImages', (multipleSelection=false, callback=false) =>
      @options.multipleSelection = multipleSelection
      @layout.show(callback)

    chr.commands.setHandler 'hideImages', =>
      @layout.hide()