require 'logger'

# this module is meant to be mixed in at a class level
# e.g.
# class Foo
#   extend Lager
#   ...
# end
#
# It provides the class variable @@lager, which may be used in class or
# instance methods.
#
# e.g. @@lager.debug { "example log message" }
#
# Note that using the block invocation means that the block contents are
# not evaluated if the log level is above the message level.
#
# The tricky part to using @@lager is making sure that it's already been
# defined.  In an instance context, this is fairly easy.  Make sure to call
# self.class.fresh_lager, presumably with a log destination.  If you want
# to set or change the log destination, call fresh_lager.
#
# In a class context, you are probably not setting the log destination.
# Rather than calling fresh_lager, which will set the log destination to
# $stderr by default, you should call ensure_lager.  If @@lager already exists,
# then you won't overwrite it.
#
# Usage:
#
# Guard any calls to @@lager in class methods with ensure_lager at the top of
# the method
#
# Guard any calls to @@lager in instance methods with fresh_lager in initialize
#
# After setting the default log level in initialize, only ever call the
# message methods: debug, info, warn, error, fatal within your class code.
# Let the destination and log level be managed from outside.
#
module Lager
  def self.version
    vpath = File.join(File.dirname(__FILE__), '..', 'VERSION')
    File.read(vpath).chomp
  end

  def ensure_lager
    fresh_lager unless defined? @@lager
  end

  def fresh_lager(dest = nil, level = :warn)
    case dest
    when nil, 'stderr', 'STDERR'
      dest = $stderr
    when 'stdout', 'STDOUT'
      dest = $stdout
    when IO
      # do nothing
    when String
      # assume file path, do nothing
    else
      raise "unable to log_to #{dest} (#{dest.class})"
    end
    @@lager = Logger.new dest
    @@lager.formatter = proc { |sev, time, progname, msg|
      line = "[#{time.strftime('%Y-%m-%d %H:%M:%S')}] #{sev.to_s.upcase}: "
      line << "(#{progname}) " if progname
      line << msg << "\n"
    }
    log_level = level
    nil # don't expose @@lager outside of the class mixing this in
  end

  def log_level= sym
    ensure_lager
    case sym
    when Symbol, String
      begin
        @@lager.level = Logger.const_get(sym.to_s.upcase)
      rescue NameError
        raise "unknown log level #{sym}"
      end
    when Numeric
      @@lager.level = sym
    else
      raise "unknown log level: #{sym}"
    end
  end
end
