require "helper"
require "fluent/plugin/out_unwindjsonarray.rb"

class UnwindjsonarrayOutputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::UnwindjsonarrayOutput).configure(conf)
  end
end
