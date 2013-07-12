require 'logger'

# this module is meant to be mixed in at a class level
# e.g.
# class Foo
#   extend Lager
#   log_to '/tmp/foo.log'
#   ...
# end
#
# It provides the class instance variable @lager, which may be used in class
# methods, e.g.
#
# def self.foo
#   @lager.debug { "example log message" }
# end
#
# Make sure to call log_to within the class definition, so that class methods
# will already have @lager defined at requiretime.
#
# For instance methods, you need to set @lager directly, within initialize
# Note: the instance layer and class layer each have their own independent
#       @lager
# Here we will make the instance @lager reference the class @lager
#
# def initialize
#   @lager = self.class.lager
# end
#
module Lager
  def self.version
    file = File.expand_path('../../VERSION', __FILE__)
    File.read(file).chomp
  end

  # create @lager from dest; return dest
  # if passed a Logger instance, set @lager to that instance and return
  # supports IO and String (filename, presumably) for log destination
  # (passed straight through to Logger.new)
  # supports symbols, strings, and integers for log level
  #
  def log_to(dest, level = nil)
    return (@lager = dest) if dest.is_a?(Logger)
    # use the old @lager's level by default, as appropriate
    level ||= (defined?(@lager) ? @lager.level : :warn)
    @lager = Logger.new dest
    @lager.formatter = proc { |sev, time, progname, msg|
      line = "[#{time.strftime('%Y-%m-%d %H:%M:%S')}]"
      line << sev.to_s.upcase.rjust(5) << ":"
      line << "(#{progname})" if progname
      line << " #{msg}\n"
    }
    self.log_level = level
    dest # don't expose @lager here
  end

  # returns a symbol e.g. :debug -- possibly :unknown
  #
  def log_level
    raise "no @lager available" unless defined?(@lager)
    [:debug, :info, :warn, :error, :fatal][@lager.level] || :unknown
  end

  # :debug, 'debug', and Logger::DEBUG (0) are all supported
  #
  def log_level=(level)
    raise "no @lager available" unless defined?(@lager)
    case level
    when Symbol, String
      begin
        @lager.level = Logger.const_get(level.to_s.upcase)
      rescue NameError
        @lager.unknown "unknown log level: #{level}"
      end
    when Numeric
      if level < Logger::UNKNOWN
        @lager.level = level
      else
        @lager.unknown "unknown log level: #{level}"
      end
    else
      @lager.unknown "unknown log level: #{level} (#{level.class})"
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
