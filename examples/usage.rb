require 'lager'

class Foo
  extend Lager
  log_to $stdout, :debug  # sets up @lager at the class layer

  def self.bar(baz)
    unless baz.is_a?(String)
      @lager.debug { "baz #{baz} is a #{baz.class}, not a string" }
    end
  end

  def initialize
    # set the instance layer's @lager to the class layer's @lager
    @lager = self.class.lager
    # now both layers are using the same instance
  end

  def do_something_complicated
    @lager.debug { "about to do something complicated" }
    # ...
    @lager.debug { "whew! we made it!" }
  end
end

if __FILE__ == $0
  puts "About to spew debug messages"
  Foo.bar(15)
  f = Foo.new
  f.do_something_complicated

  puts "Now updating Foo's log level"
  Foo.log_level = :warn
  Foo.new.do_something_complicated

  puts "Now the same calls as before"
  Foo.bar(15)
  f = Foo.new
  f.do_something_complicated
end
