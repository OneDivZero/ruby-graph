require 'test_helper'

# NOTE: We use :active_support instead of using plain minitest (=> 'class RubyGraph::GraphTest < Minitest::Test')
class RubyGraph::GraphTest < ActiveSupport::TestCase
  def test_it_does_something_useful
    puts 'TEST RubyGraph::GraphTest is watched by guard'

    assert true
  end

  # def test_graph_has_a_name_by_default
  #   puts 'graph_has_a_name'
  #   g = RubyGraph::Graph.build
  #   #binding.pry
  #   #bp

  #   assert_not_nil g.name
  #   assert_equal g.name, g.object_id
  # end

  # def test_storage_is_empty
  # end
end
