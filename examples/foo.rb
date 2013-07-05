require_relative '../lib/lager'

class Foo
  extend Lager

  # set logging from within, useful for default behavior
  #
  log_to $stdout, :warn

  def self.bar
    @lager.debug { "inside Foo.bar" }
  end

  def initialize(log_dest = nil)
    # Optional: set logging via instantiation
    #     Note: for the whole class
    #
    self.class.log_to(log_dest) if log_dest

    # always make sure to assign @lager at the instance layer
    #
    @lager = self.class.lager

    @lager.debug { "inside Foo#initialize" }
  end
end

if __FILE__ == $0
  Foo.bar
  Foo.new
  Foo.new $stderr

  # set logging from outside
  #
  Foo.log_to $stdout
  Foo.log_level :debug

  Foo.bar
  Foo.new
end
