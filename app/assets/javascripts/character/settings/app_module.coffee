

class @SettingsAppModule
  constructor: (name, opts={}) ->
    opts.name = name
    opts.path ?= _.slugify(name)

    character.module "Settings.#{opts.path}", ->
      @options = opts