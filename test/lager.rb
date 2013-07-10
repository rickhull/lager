require 'minitest/spec'
require 'minitest/autorun'

require 'tempfile'

require_relative '../lib/lager'

# useful Foo class
# calls log_to at require time
#
require_relative '../examples/foo'

describe Lager do
  describe ".version" do
    it "must return a string of numbers and dots" do
      Lager.version.must_match %r{\A[0-9\.]+\z}
    end
  end

  describe "#log_to" do
    it "must have created a Logger" do
      # note, the useful Foo class has already called log_to
      Foo.lager.must_be_instance_of(Logger)
    end

    it "must return nil" do
      Foo.log_to($stdout).must_equal $stdout
    end

    it "must use an existing Logger when provided" do
      l = Logger.new($stderr)
      Foo.log_to l
      Foo.lager.must_equal l
      Foo.log_level = :info
      Foo.bar # does debug logging, should be silent
      Foo.lager.must_equal l
    end

    it "must handle a Tempfile when provided" do
      t = Tempfile.new('lager')
      Foo.log_to t
      Foo.log_level = :debug
      Foo.bar # does debug logging
      t.rewind
      t.read.wont_be_empty
      t.close
      t.unlink
    end

    it "must handle a path to /tmp when provided" do
      fname = '/tmp/lager.log'
      Foo.log_to fname
      Foo.log_level = :debug
      Foo.bar # does debug logging
      Foo.log_to $stderr
      File.exists?(fname).must_equal true
      File.unlink fname
    end
  end

  describe "#log_level=" do
    before do
      Foo.log_level = :fatal
    end

    it "must accept :debug as :debug" do
      Foo.log_level = :debug
      Foo.log_level.must_equal :debug
    end

    it "must accept Logger::INFO as :info" do
      Foo.log_level = Logger::INFO
      Foo.log_level.must_equal :info
    end

    it "must accept 'warn' as :warn" do
      Foo.log_level = 'warn'
      Foo.log_level.must_equal :warn
    end

    def must_ignore level
      lev = Foo.log_level
      Foo.log_level = level
      Foo.log_level.must_equal lev
    end

    it "must ignore a bad symbol" do
      must_ignore :bedug
    end

    it "must ignore an unexpected object" do
      must_ignore Array
    end

    it "must ignore a bad integer" do
      must_ignore 42
    end

    it "must ignore Logger::UNKNOWN" do
      must_ignore Logger::UNKNOWN
    end
  end
end
