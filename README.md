Lager
=====
Lager is a logging mixin.  It is designed to add class methods for logging, via extend.  It aims to provide a unified logging interface that you can use in both class and instance methods.  It is implemented with the familiar [Logger class](http://ruby-doc.org/stdlib-2.0/libdoc/logger/rdoc/Logger.html) from ruby's [stdlib](http://ruby-doc.org/stdlib/).  Only one Logger instance is used for this.  You are able to set the log destination and log level from within the class, via instantiation, or from outside.

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

    [2013-07-05 15:14:52] DEBUG: baz 15 is a Fixnum, not a string
    [2013-07-05 15:14:52] DEBUG: about to do something complicated
    [2013-07-05 15:14:52] DEBUG: whew! we made it!


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

Best practices
--------------
* Set default logging inside the class definition by calling log_to just after extend Lager
* Set the instance layer's @lager within #initialize
* Only call message methods (debug, info, warn, error, fatal) on @lager in your class and instance methods.
* Beyond the class default, let the log destination and log level be managed from the outside, by the users of your class.

For Logger, generally: use block invocation of message methods.

    @lager.debug { "hi" }
    # rather than
    @lager.debug "hi"

    # By using the first form, the block will not be evaluated unless we
    # are logging at DEBUG level.
    # If using the second form, the message is evaluated no matter the current
    # log level.  This can be significant when logging complicated messages.

Artifacts
---------
* By mixing in Lager via extend, you introduce these class methods:
  * lager
  * log_to
  * log_level
* By calling log_to, you introduce the class instance variable @lager
* By assigning @lager within initialize, you introduce the instance variable @lager

Now you have a unified interface for logging at both class and instance layers.

    @lager.info { "So happy right now!" }
