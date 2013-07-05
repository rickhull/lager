require 'logger'

# this module is meant to be mixed in at a class level
# e.g.
# class Foo
#   extend Lager
#   log_to '/tmp/foo.log'
#   ...
# end
#
# It provides the class instance variable @lager, which may be used in class methods
#
# e.g. @lager.debug { "example log message" }
#
# Note that using the block invocation means that the block contents are
# not evaluated if the log level is above the message level.
#
# Make sure to call log_to within the class definition, so that class methods
# will already have @lager defined.

# For instance methods, you need to set @lager directly, within initialize
# Note: the instance layer and class layer each have their own independent
#       @lager
# Here we will make the instance @lager reference the class @lager
#
# def initialize
#   @lager = self.class.lager
# end
#
# Outside of initialize or a call to log_to within the class definition,
# you should only ever call the message methods: debug, info, warn, error,
# and fatal within your class code.
#
# Let the destination and log level be managed from outside.
#
module Lager
  def self.version
    vpath = File.join(File.dirname(__FILE__), '..', 'VERSION')
    File.read(vpath).chomp
  end

  # create @lager
  # supports IO and String (filename, presumably) for log destination
  # (passed straight through to Logger.new)
  # supports symbols, strings, and integers for log level
  #
  def log_to(dest = $stderr, level = nil)
    # use the old @lager's level by default, as appropriate
    level ||= (defined?(@lager) ? @lager.level : :warn)
    @lager = Logger.new dest
    @lager.formatter = proc { |sev, time, progname, msg|
      line = "[#{time.strftime('%Y-%m-%d %H:%M:%S')}] #{sev.to_s.upcase}: "
      line << "(#{progname}) " if progname
      line << msg << "\n"
    }
    log_level level
    nil # don't expose @lager here
  end

  # call without argument to get the log level
  # call with argument to set the log level
  # :debug, 'debug', and Logger::DEBUG (0) are all supported
  #
  def log_level(level = nil)
    raise "no @lager available" unless defined?(@lager)
    case level
    when nil
      @lager.level
    when Symbol, String
      begin
        @lager.level = Logger.const_get(level.to_s.upcase)
      rescue NameError
        raise "unknown log level #{level}"
      end
    when Numeric
      @lager.level = level
    else
      raise "unknown log level: #{level}"
    end
  end

  # provide access to the class instance variable
  # typically only used within initialize
  #
  def lager
    log_to unless defined?(@lager)
    @lager
  end
end
