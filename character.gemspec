# -*- encoding: utf-8 -*-
require File.expand_path('../lib/character/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'character'
  gem.version       = Character::VERSION
  gem.summary       = 'Admin framework for rails + mongoid web applications.'
  gem.license       = 'MIT'
  gem.description   = ''

  gem.authors       = [ 'Alexander Kravets', 'Roman Lupiichuk', 'Maksym Melnyk', 'Anthony Blackwell' ]
  gem.email         = 'alex@slatestudio.com'
  gem.homepage      = 'https://github.com/slate-studio/character'

  gem.require_paths = ['lib']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  # Supress the warning about no rubyforge project
  gem.rubyforge_project = 'nowarning'

  # javascript
  gem.add_runtime_dependency 'underscore-rails'
  gem.add_runtime_dependency 'marionette-rails', '~> 2.0.0'
  gem.add_runtime_dependency 'jquery-ui-rails'
  gem.add_runtime_dependency 'momentjs-rails'
  gem.add_runtime_dependency 'character_editor'
  gem.add_runtime_dependency 'modernizr-rails'

  # css
  gem.add_runtime_dependency 'compass-rails'
  gem.add_runtime_dependency 'font-awesome-rails'
  gem.add_runtime_dependency 'rhythm'
  gem.add_runtime_dependency 'simple_form_scss'

  # authentication
  gem.add_runtime_dependency 'browserid-auth-rails', '~> 0.5.7'

  # orm
  gem.add_runtime_dependency 'mongoid', '~> 4.0.0'

  # forms
  gem.add_runtime_dependency 'simple_form'
  gem.add_runtime_dependency 'nested_form'

  # pagination
  gem.add_runtime_dependency 'kaminari'

  # blog
  gem.add_runtime_dependency 'mongoid_slug'
  gem.add_runtime_dependency 'mongoid_search'
  gem.add_runtime_dependency 'mini_magick'
  gem.add_runtime_dependency 'meta-tags'

  # analytics
  gem.add_runtime_dependency 'google-api-client'

  # automated tests
  gem.add_development_dependency 'rails', '~> 4.1.2'
  gem.add_development_dependency 'database_cleaner'
  gem.add_development_dependency 'factory_girl_rails'
  gem.add_development_dependency 'minitest-reporters'
  gem.add_development_dependency 'minitest-focus'
end