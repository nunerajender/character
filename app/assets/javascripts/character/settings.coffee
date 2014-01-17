#= require_tree ./settings

@CharacterSettingsApp = (name, options={}) ->
  options.name               = name
  options.path              ?= _.slugify(name)
  options.detailsViewClass  ?= Character.Settings.DetailsView

  chr.module "Settings.#{options.path}", -> @options = options

@CharacterSettingsAdmins = ->
  CharacterSettingsApp('Admins')