# -*- encoding: utf-8 -*-
require File.expand_path('../lib/character/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'character'
  gem.version       = Character::VERSION
  gem.summary       = 'Admin framework for rails + mongoid web applications.'
  gem.license       = 'MIT'
  gem.description   = ''

  gem.authors       = [ 'Alexander Kravets', 'Roman Lupiichuk', 'Maksym Melnyk' ]
  gem.email         = 'alex@slatestudio.com'
  gem.homepage      = 'https://github.com/slate-studio/character'

  gem.require_paths = ['lib']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  # Supress the warning about no rubyforge project
  gem.rubyforge_project = 'nowarning'

  # frontend javascript
  gem.add_runtime_dependency 'underscore-rails'
  gem.add_runtime_dependency 'marionette-rails'
  ## this is used for items reordering
  gem.add_runtime_dependency 'jquery-ui-rails'
  ## helpers
  gem.add_runtime_dependency 'momentjs-rails'
  gem.add_runtime_dependency 'character_editor'

  # css
  gem.add_runtime_dependency 'compass-rails'
  gem.add_runtime_dependency 'foundation-rails'
  gem.add_runtime_dependency 'font-awesome-rails'

  # authentication
  gem.add_runtime_dependency 'browserid-auth-rails'

  # forms
  gem.add_runtime_dependency 'simple_form'
  gem.add_runtime_dependency 'nested_form'

  # pagination
  gem.add_runtime_dependency 'kaminari'

  # blog backend
  # gem.add_runtime_dependency 'mongoid' <- for now you have to pick github version manually for Rails 4
  # gem.add_runtime_dependency 'bson_ext'
  gem.add_runtime_dependency 'mongoid_slug'
  gem.add_runtime_dependency 'mongoid_search'
  gem.add_runtime_dependency 'mini_magick'

  # blog seo
  gem.add_runtime_dependency 'meta-tags'

  # testing
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'database_cleaner'
  gem.add_development_dependency 'factory_girl_rails', '~> 4.0'
end