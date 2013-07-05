require 'logger'

module Lager
  def self.version
    vpath = File.join(File.dirname(__FILE__), '..', 'VERSION')
    File.read(vpath).chomp
  end


# this module is meant to be mixed in at a class level
# e.g.
# extend Lager
#
  def log_to dest=nil
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
    if defined?(@@log)
      l = Logger.new dest
      l.formatter = @@log.formatter
      l.level = @@log.level
      @@log = l
    else
      @@log = Logger.new dest
      @@log.formatter = proc { |sev, time, progname, msg|
        line = "[#{time.strftime('%Y-%m-%d %H:%M:%S')}] #{sev.to_s.upcase}: "
        line << "(#{progname}) " if progname
        line << msg << "\n"
      }
      @@log.level = Logger::WARN
    end
    @@log
  end

  def log_level=(sym)
    log_to unless defined?(@@log)
    level = Logger.const_get(sym.to_s.upcase)
    raise "unknown log level #{sym}" unless level
    @@log.level = level
  end
end
