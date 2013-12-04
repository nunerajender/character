require 'rubygems/package_task'

spec = Gem::Specification.load(Dir['*.gemspec'].first)
gem = Gem::PackageTask.new(spec)
gem.define()


# This will let us run our tests by typing "rake spec" from the gem root folder
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')