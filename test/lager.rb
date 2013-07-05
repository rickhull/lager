require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/lager.rb'

describe Lager do
  before do
    @foo_class = class Foo; end
    @foo_class.extend(Lager)
  end

  describe "#lager" do
    it "must have a valid Logger instance with no dest" do
      @foo_class.lager.must_be_instance_of(Logger)
    end
  end

  describe "#log_level" do
    it "must accept :debug without raising" do
      @foo_class.log_level = :debug
    end
  end
end
