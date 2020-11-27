require 'test_helper'

# NOTE: We use :active_support instead of using plain minitest (=> 'class RubyGraph::GraphTest < Minitest::Test')
class RubyGraph::GraphTest < ActiveSupport::TestCase
  def test_it_does_something_useful
    puts 'RubyGraph::GraphTest: is watched by guard'

    assert true
  end
end
