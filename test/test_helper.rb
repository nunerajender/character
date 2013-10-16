require 'minitest/autorun'
require 'minitest/pride'


class Character::TestCase < Minitest::Test
  def self.test(name, &block)
    define_method("test_#{name.inspect}", &block)
  end

  def self.setup(&block)
    define_method("setup", &block)
  end
end
