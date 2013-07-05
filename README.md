Lager
=====
Lager is a logging mixin.  It is designed to add class methods for logging

How it works
------------
Lager is a mixin.  By design, it mixes in class methods.

    require 'lager'

    class Foo
      extend Lager
    end

Now, within Foo, you can use the class variable @@lager for logging.

    class Foo
      extend Lager

      def self.bar(baz)
        lager unless defined?(@@lager)
        unless baz.is_a?(String)
          @@lager.debug { "baz: #{baz} is not a string" }
        end
      end
