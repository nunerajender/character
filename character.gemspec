# -*- encoding: utf-8 -*-
require File.expand_path('../lib/character/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'character'
  gem.version       = Character::VERSION
  gem.summary       = 'Data management framework'
  gem.description   = ''
  gem.license       = ''

  gem.authors       = ['Alexander Kravets']
  gem.email         = 'alex@slatestudio.com'
  gem.homepage      = 'https://github.com/slate-studio/character'

  gem.require_paths = ['lib']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  # Supress the warning about no rubyforge project
  gem.rubyforge_project = 'nowarning'

  # assets

  # stylesheets
  gem.add_runtime_dependency 'compass-rails'
  gem.add_runtime_dependency 'zurb-foundation'

  # javascript
  gem.add_runtime_dependency 'jquery-ui-rails'
  gem.add_runtime_dependency 'underscore-rails'
  gem.add_runtime_dependency 'marionette-rails'
  gem.add_runtime_dependency 'eco'

  # TODO: we just need to have one set of icons which are used
  #       in core to keep code small and fast
  gem.add_runtime_dependency 'foundation-icons-sass-rails'
  gem.add_runtime_dependency 'font-awesome-sass-rails'

  # browserid auth
  # TODO: replace with devise + browser id support
  gem.add_runtime_dependency 'browserid-auth-rails'
  gem.add_runtime_dependency 'devise'

  # forms are autogenerated for editable mongoid models
  gem.add_runtime_dependency 'simple_form'

  # index action pagination feature is implemented
  # using kaminari library
  gem.add_runtime_dependency 'kaminari'
end


