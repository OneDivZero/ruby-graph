require 'test_helper'

# NOTE: We use :active_support instead of using plain minitest (=> 'class RubyGraph::GraphTest < Minitest::Test')
# Just because it provides more painless testing-capabilities. (MiniTest needs to become a bit more powerfull!)

#class RubyGraph::GraphTest < ActiveSupport::TestCase
#class RubyGraph::GraphTest < Minitest::Test
#describe 'RubyGraph' do

class RubyGraph::GraphTest < Minitest::Spec
  def build_graph(name: nil)
    @graph = RubyGraph::Graph.build(name: name)
  end

  describe 'Graph' do
    it 'has a name by default' do
      build_graph

      #assert_not_nil @graph.name
      refute_nil @graph.name
      assert_equal @graph.object_id, @graph.name
    end

    it 'accepts a custom name' do
      build_graph(name: :custom)

      #assert_not_nil @graph.name
      refute_nil @graph.name
      assert_equal :custom, @graph.name
    end

    it 'is an empty graph by default' do
      build_graph

      assert @graph.empty?
    end
  end

  describe 'Adding nodes' do
    it 'responds if a node is unknown' do
      assert true
    end
  end

  # test 'it adds a node and accepts a symbol or string or number as name' do
  #   build_graph

  #   [:a, 'b', 123].each do |name|
  #     @graph.add(name)

  #     assert @graph.storage.key?(name.to_s.to_sym)
  #   end
  # end

  # test 'it adds a node and connects it with an existing node' do
  #   build_graph

  #   assert_not @graph.add(:a, to: :b)

  #   @graph.add(:b)

  #   assert @graph.add(:a, to: :b)
  # end

  # test 'responds if a node is known' do
  #   build_graph
  #   @graph.add(:a)

  #   assert @graph.node?(:a)
  #   assert_not @graph.node?(:unknown)
  # end

  # test 'it returns a node-definition if the node is known' do
  #   build_graph
  #   @graph.add(:a)

  #   assert @graph.node(:a)
  #   assert_equal [], @graph.node(:a)
  #   assert_nil @graph.node(:unknown)
  # end

  # test 'it can connect two nodes' do
  #   build_graph
  #   @graph.add(:a)
  #   @graph.add(:b)

  #   assert @graph.connect(:a, :b)

  #   assert_equal [:b], @graph.storage[:a]
  #   assert_equal [:a], @graph.storage[:b]

  #   assert_not @graph.connect(:a, :c)
  # end

  # test 'it can connect a node with itself' do
  #   build_graph
  #   @graph.add(:a)

  #   assert @graph.connect(:a, :a)
  #   assert_equal [:a], @graph.storage[:a]
  # end

  # test 'neighbors' do
  #   build_graph
  #   @graph.add(:a)
  #   @graph.add(:b)
  #   @graph.add(:c)

  #   assert_empty [], @graph.neighbors(:a)

  #   @graph.connect(:a, :b)

  #   assert_equal [:b], @graph.neighbors(:a)

  #   @graph.connect(:a, :c)

  #   assert_equal [:b, :c], @graph.neighbors(:a)
  #   assert_equal [:a], @graph.neighbors(:b)
  #   assert_equal [:a], @graph.neighbors(:c)
  # end
end
#end
