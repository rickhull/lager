Lager
=====
Lager is a logging mixin.  It is designed to add class methods for logging, via extend.  It aims to provide a unified logging interface that you can use in both class and instance methods.  Only one Logger instance is used for this.  You are able to set the log destination and log level from within the class, via instantiation, or from outside.

Best practice is to set default logging inside the class definition, set the instance layer's @lager within #initialize, and then only call message methods (debug, info, warn, error, fatal) on @lager in your class and instance methods.  Let the log destination and log level be managed from the outside, by the users of your class.

Usage
-----
    require 'lager'

    class Foo
      extend Lager
      log_to $stdout, :debug  # sets up @lager at the class layer
      # ...

Now, within Foo, you can use the class instance variable @lager for logging.

      # ...
      def self.bar(baz)
        unless baz.is_a?(String)
          @lager.debug { "baz #{baz} is a #{baz.class}, not a string" }
        end
      end
      # ...

What about instance methods, you ask?  Well, you will need to assign @lager yourself, within #initialize.

      # ...
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

Everything under control
------------------------
Right now, Foo is spewing debug messages everywhere:

    Foo.bar(15)
    f = Foo.new
    f.do_something_complicated

This is because we set the default logging to :debug level, above:

    class Foo
      extend Lager
      log_to $stdout, :debug  # sets up @lager at the class layer

Now let's calm things down:

    Foo.log_level :warn
    Foo.new.do_something_complicated

We can tell Foo to log to a file:

    Foo.log_to '/tmp/foo.log'

Note that this will create a new Logger instance.  The old log level will be maintained unless you specify a new one.
