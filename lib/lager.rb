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
  def new_lager dest=nil
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
    @lager = Logger.new dest
    @lager.formatter = proc { |sev, time, progname, msg|
      line = "[#{time.strftime('%Y-%m-%d %H:%M:%S')}] #{sev.to_s.upcase}: "
      line << "(#{progname}) " if progname
      line << msg << "\n"
    }
    @lager.level = Logger::WARN
    @lager
  end

  def lager
    @lager or new_lager
  end

  def log_level=(sym)
    level = Logger.const_get(sym.to_s.upcase)
    raise "unknown log level #{sym}" unless level
    self.lager.level = level
  end
end
