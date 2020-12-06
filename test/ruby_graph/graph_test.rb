require 'test_helper'

class RubyGraph::GraphTest < RubyGraph::SpecTest
  UNACCEPTABLE_DATA_TYPES = [Array, Hash, Object].freeze

  describe 'Building a graph' do
    it 'builds a graph when using the test-helper-method :build_graph' do
      assert_instance_of RubyGraph::Graph, build_graph
    end

    it 'has always a name (defaults to object_id)' do
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

    it 'builds a graph with an initial defined setting of nodes' do
      nodes = %i[a b c]
      build_graph(with: nodes)

      nodes.each do |name|
        assert @graph.store.key?(name)
      end
    end

    it 'allows reading-access to internal data-structure' do
      build_graph

      assert_respond_to @graph, :store
      assert_not_respond_to @graph, :'store='
    end
  end

  describe 'Adding nodes' do
    it 'adds a node' do
      build_graph

      @graph.add(:a)

      assert @graph.store.key?(:a)
    end

    it 'accepts a symbol or a string or a number as node-name' do
      build_graph

      [:a, 'b', 123].each do |name|
        @graph.add(name)

        assert @graph.store.key?(name.to_s.to_sym)
      end
    end

    # rubocop:disable Style/NumericLiteralPrefix
    it 'does not accept a number with an leading zero' do
      build_graph

      @graph.add(0221)

      assert_not @graph.store.key?(:'0221')
    end

    it 'does not accept a number with an leading zero but it adds the node using the octal representation' do
      build_graph

      @graph.add(0221)

      # expected = 0221.to_s.to_sym

      assert @graph.store.key?(:'145')
    end
    # rubocop:enable Style/NumericLiteralPrefix

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

    it 'ensures if a node is known' do
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

    it 'ensures if a list of nodes is known' do
      nodes = %i[a b]
      build_graph(with: nodes)

      assert @graph.known?(:a)
      assert @graph.known?(:a, :b)
      assert @graph.known?(*nodes)

      assert_not @graph.known?(:c)
      assert_not @graph.known?(:c, :d)
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

  describe 'Adjacence of nodes' do
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

    it 'ensures if two nodes are adjacent' do
      build_graph(with: %i[a b])

      @graph.connect(:a, :b)

      assert @graph.adjacent?(:a, :b)
      assert @graph.adjacent?(:b, :a)
    end

    it 'ensures if a node is adjacent with itself' do
      build_graph(with: %i[a])

      @graph.connect(:a, :a)

      assert @graph.adjacent?(:a, :a)
    end
  end

  describe 'Incidence of nodes' do
    it 'ensures if a node is incident with a given edge-definition' do
      build_graph(with: %i[a b])

      @graph.connect(:a, :b)

      assert @graph.incident?(:a, %i[a b])
    end

    it 'fails if the node is not incident' do
      build_graph(with: %i[a b])

      assert_not @graph.incident?(:a, %i[a b])
    end

    it 'fails if the node is unknown' do
      build_graph(with: %i[a b])

      @graph.connect(:a, :b)

      assert_not @graph.incident?(:c, %i[a b])
    end

    it 'fails if the node is not part of the edge-definition' do
      build_graph(with: %i[a b])

      @graph.connect(:a, :b)

      assert_not @graph.incident?(:a, %i[a c])
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

  # TODO: Move tests concerning 'when using internal method :key_for'
  # describe 'Failing hard when using internal method :key_for' do
  #   before_each do
  #     RubyGraph::Graph.send :public, :key_for

  #     build_graph

  #     assert_respond_to @graph, :key_for
  #   end
  # end

  # TODO: We should test every method, which accesses / should / must access private method :key_for in graph-class
  describe 'Failing hard for nonconforming node-names' do
    # TODO: aggregate all access-methods here and use a methods named :fails_when or :fails_for substituting :it
    # e.g. fails_for '#adjacent?' do ... end

    it 'does not fail for internal method :key_for when using a symbol, string or an integer' do
      RubyGraph::Graph.send :public, :key_for

      build_graph

      assert_respond_to @graph, :key_for

      assert_equal :a, @graph.key_for(:a)
      assert_equal 'a'.to_sym, @graph.key_for('a')
      assert_equal :'123', @graph.key_for(123)
    end

    it 'fails for internal method :key_for if node-name is nil' do
      RubyGraph::Graph.send :public, :key_for

      build_graph

      assert_respond_to @graph, :key_for

      assert_raises(RubyGraph::Graph::InvalidNode) { @graph.key_for(nil) }
    end

    # TODO: Is this maybe a case for mutant-testing ?! We can not do a test for every existing class :D
    it 'fails for internal method :key_for when using an arbitrary data-type' do
      RubyGraph::Graph.send :public, :key_for

      build_graph

      assert_respond_to @graph, :key_for

      UNACCEPTABLE_DATA_TYPES.each do |class_name|
        assert_raises(RubyGraph::Graph::InvalidNode) { @graph.key_for(class_name.new) }
      end
    end

    it 'fails for #node' do
      build_graph

      assert_raises(RubyGraph::Graph::InvalidNode) { @graph.node([]) }
    end

    it 'fails for #node?' do
      build_graph

      assert_raises(RubyGraph::Graph::InvalidNode) { @graph.node?([]) }
    end

    it 'fails for #adjacent?' do
      build_graph

      assert_raises(RubyGraph::Graph::InvalidNode) { @graph.adjacent?([], :b) }
      assert_raises(RubyGraph::Graph::InvalidNode) { @graph.adjacent?(:a, []) }
    end

    it 'fails for incident?' do
      build_graph

      assert_raises(RubyGraph::Graph::InvalidNode) { @graph.incident?([], %i[a b]) }
    end
  end

  describe 'Failing hard for nonconforming edge-definitions' do
    it 'fails for incident?' do
      build_graph

      assert_raises(RubyGraph::Graph::InvalidEdge) { @graph.incident?(:a, []) }
      assert_raises(RubyGraph::Graph::InvalidEdge) { @graph.incident?(:a, [:a]) }

      UNACCEPTABLE_DATA_TYPES.each do |class_name|
        assert_raises(RubyGraph::Graph::InvalidEdge) { @graph.incident?(:a, [class_name.new]) }
      end
    end
  end
end
