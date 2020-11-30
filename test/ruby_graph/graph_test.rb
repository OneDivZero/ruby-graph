require 'test_helper'

# NOTE: We use :active_support instead of using plain minitest (=> 'class RubyGraph::GraphTest < Minitest::Test')
class RubyGraph::GraphTest < ActiveSupport::TestCase
  test 'it has a name by default' do
    g = RubyGraph::Graph.build

    assert_not_nil g.name
    assert_equal g.object_id, g.name
  end

  test 'it could have a custom name' do
    g = RubyGraph::Graph.build(name: 'custom')

    assert_not_nil g.name
    assert_equal 'custom', g.name
  end
end
