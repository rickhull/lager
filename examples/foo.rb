require 'lager'

class Foo
  extend Lager

  # set logging from within, useful for default behavior
  #
  log_to $stdout, :warn

  def self.bar
    @lager.debug { "inside Foo.bar" }
  end

  def initialize
    # assign @lager at the instance layer if you want to use it
    # @lager, here, is technically a different variable than used above
    # though we are setting them to the same thing
    #
    @lager = self.class.lager
    @lager.debug { "inside Foo#initialize" }
  end
end

if __FILE__ == $0
  Foo.bar
  Foo.new

  # set logging from outside
  #
  puts "Turning on debug logging"
  Foo.log_to $stderr
  Foo.log_level :debug

  Foo.bar
  Foo.new
end
