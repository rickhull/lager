require 'logger'

module Lager
  def self.version
    vpath = File.join(File.dirname(__FILE__), '..', 'VERSION')
    File.read(vpath).chomp
  end


# this module is meant to be mixed in at a class level
# e.g.
# class Foo
#   extend Lager
#   ...
# end
#
# Foo.lager
#
  def lager dest=nil
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
    if defined?(@@lager)
      l = Logger.new dest
      l.formatter = @@lager.formatter
      l.level = @@lager.level
      @@lager = l
    else
      @@lager = Logger.new dest
      @@lager.formatter = proc { |sev, time, progname, msg|
        line = "[#{time.strftime('%Y-%m-%d %H:%M:%S')}] #{sev.to_s.upcase}: "
        line << "(#{progname}) " if progname
        line << msg << "\n"
      }
      @@lager.level = Logger::WARN
    end
    @@lager
  end

  def log_level=(sym)
    log_to unless defined?(@@lager)
    level = Logger.const_get(sym.to_s.upcase)
    raise "unknown log level #{sym}" unless level
    @@lager.level = level
  end
end
