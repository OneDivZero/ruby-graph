require 'test_helper'

class RubyGraphTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyGraph::VERSION
  end

  def test_it_does_something_useful
    # assert false
    puts 'TEST is watched by guard'

    assert true
  end
end
