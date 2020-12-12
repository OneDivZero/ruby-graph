module RubyGraph
  module Abilities
    # A graph is called empty, if it has no nodes
    def empty?
      @store.empty?
    end

    # A graph is called simple, if it has no loops and no parallel edges
    def simple?
      proof = true

      return proof if nodes.empty? || edges.empty?

      proof &= proof_on_no_loops?

      return false unless proof # no need to test second condition if graph has already loops

      # NOTE: Array.without does not support arrays as elements #1
      # proof &= edges.sort.reduce(proof) { |result, edge| result && !edges.dup.without(edge).include?(edge) }

      proof &= proof_on_no_parallels?
    end

    private def proof_on_no_loops?
      edges.reduce(true) { |result, edge| result && !loop?(edge) }
    end

    # TODO: This method is invalid, cause method :edges only returns a flat list without parallel defined edges #1
    # e.g. this results in: [[:a, :b], [:b, :c]] instead of [[:a, :b], [:b, :c], [:c, :b]]
    # cause the underlying storage of nodes 'links' every node with another node, which does not reflect the orgin
    # definition of an edge. Thus we need to seperate the set of edges and should not derive it from node-definition
    # @graph.connect(:a, :b)
    # @graph.connect(:b, :c)
    # @graph.connect(:c, :b)
    private def proof_on_no_parallels?
      edges.reduce(true) do |result, edge|
        edges.each do |other_edge|
          next if edge.eql?(other_edge)

          result && !parallel?(edge, other_edge)
        end
      end
    end
  end
end
