require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/lager'
require_relative '../examples/foo' # useful Foo class

describe Lager do
  describe ".version" do
    it "must return a string of numbers and dots" do
      Lager.version.must_match %r{\A[0-9\.]+\z}
    end
  end
  describe "#log_to" do
    # note, the useful Foo class has already called log_to in the class def
    it "must have created a Logger" do
      Foo.lager.must_be_instance_of(Logger)
    end

    it "must return nil" do
      Foo.log_to.must_be_nil
    end
  end

  describe "#log_level" do
    it "must accept :debug without raising" do
      Foo.log_level :debug
    end

    it "must accept 1 without raising" do
      Foo.log_level 1
    end
  end
end
