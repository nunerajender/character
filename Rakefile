require 'rubygems/package_task'

spec = Gem::Specification.load(Dir['*.gemspec'].first)
gem = Gem::PackageTask.new(spec)
gem.define()


# This will let us run our tests by typing "rake test" from the gem root folder
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  # t.warning = true
  # t.verbose = true
end