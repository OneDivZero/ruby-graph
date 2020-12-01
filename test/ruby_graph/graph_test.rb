require 'test_helper'

class RubyGraph::GraphTest < RubyGraph::SpecTest
  describe 'Building a graph' do
    it 'builds a graph when using the test-helper-method :build_graph' do
      assert_instance_of RubyGraph::Graph, build_graph
    end

    it 'has a name (defaults to object_id)' do
      build_graph

      assert_not_nil @graph.name
      assert_equal @graph.object_id, @graph.name
    end

    it 'accepts a custom name' do
      build_graph(name: :custom)

      assert_not_nil @graph.name
      assert_equal :custom, @graph.name
    end

    it 'is an empty graph by default' do
      build_graph

      assert @graph.empty?
    end

    it 'builds a graph with an inital setting of nodes' do
      nodes = %i[a b c]
      build_graph(with: nodes)

      nodes.each do |name|
        assert @graph.store.key?(name)
      end
    end
  end

  describe 'Adding nodes' do
    it 'adds a node and accepts a symbol or string or number as name' do
      build_graph

      [:a, 'b', 123].each do |name|
        @graph.add(name)

        assert @graph.store.key?(name.to_s.to_sym)
      end
    end

    it 'adds a node and connects it with an existing node' do
      build_graph

      assert_not @graph.add(:a, to: :b)

      @graph.add(:b)

      assert @graph.add(:a, to: :b)
    end
  end

  describe 'Handling nodes' do
    it 'returns all nodes' do
      nodes = %i[a b c]
      build_graph(with: nodes)

      assert_equal nodes, @graph.nodes
    end

    it 'responds if a node is known' do
      build_graph
      @graph.add(:a)

      assert @graph.node?(:a)
      assert_not @graph.node?(:unknown)
    end

    it 'returns a node-definition if the node exists' do
      build_graph
      @graph.add(:a)

      assert @graph.node(:a)
      assert_equal [], @graph.node(:a)
      assert_nil @graph.node(:unknown)
    end
  end

  describe 'Connecting nodes' do
    it 'can connect a node with itself' do
      build_graph
      @graph.add(:a)

      assert @graph.connect(:a, :a)
      assert_equal [:a], @graph.store[:a]
    end

    it 'can connect two nodes' do
      build_graph(with: %i[a b])

      assert @graph.connect(:a, :b)

      assert_equal [:b], @graph.store[:a]
      assert_equal [:a], @graph.store[:b]

      assert_not @graph.connect(:a, :c)
    end
  end

  describe 'Neighborship of nodes' do
    it 'returns direct neighbors' do
      build_graph(with: %i[a b c])

      assert_empty [], @graph.neighbors(:a)

      @graph.connect(:a, :b)

      assert_equal [:b], @graph.neighbors(:a)

      @graph.connect(:a, :c)

      assert_equal %i[b c], @graph.neighbors(:a)
      assert_equal [:a], @graph.neighbors(:b)
      assert_equal [:a], @graph.neighbors(:c)
    end

    it 'responds if two nodes are adjacent' do
      build_graph(with: %i[a b])

      @graph.connect(:a, :b)

      assert @graph.adjacent?(:a, :b)
      assert @graph.adjacent?(:b, :a)
    end

    it 'responds if a node is adjacent with itself' do
      build_graph(with: %i[a])

      @graph.connect(:a, :a)

      assert @graph.adjacent?(:a, :a)
    end
  end

  describe 'Edges' do
    it 'returns a list of all edges' do
      build_graph

      assert_empty @graph.edges

      @graph.add(:a)
      @graph.add(:b)
      @graph.add(:c)

      @graph.connect(:a, :b)
      @graph.connect(:a, :c)

      assert_equal [%i[a b], %i[a c]], @graph.edges
    end

    it 'returns an edge if a node is connected with itself' do
      build_graph(with: %i[a])

      @graph.connect(:a, :a)

      assert_equal [%i[a a]], @graph.edges
    end
  end

  describe 'Removing nodes' do
    it 'fails when removing an unknown node' do
      build_graph(with: %i[a])

      assert_not @graph.remove(:unknown)
    end

    it 'removes a nodes' do
      build_graph(with: %i[a])

      assert @graph.remove(:a)
      assert_not @graph.store.key?(:a)
    end

    it 'removes all edges too' do
      build_graph(with: %i[a b c])

      @graph.connect(:a, :b)
      @graph.connect(:a, :c)

      assert @graph.remove(:a)
      assert_empty @graph.neighbors(:b)
      assert_empty @graph.neighbors(:c)

      expected = { b: [], c: [] }

      assert_equal expected, @graph.store
    end
  end
end
