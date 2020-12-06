module RubyGraph
  module Features
    # Evaluates if a node is known
    def node?(name)
      @store.key?(key_for(name))
    end

    # Evaluates if given node-list is known
    def known?(*nodes)
      nodes.reduce(true) { |result, name| result && node?(name) }
    end

    # Evaluates if two nodes are directly connected (via an implicit edge)
    def adjacent?(source, target)
      source = key_for(source)
      target = key_for(target)

      neighbors(source).include?(target)
    end

    # TODO: NOT an alias for connection between nodes, cause this must be a generic graph-method
    def connected?(); end

    # Evaluates if a given node is incident with a given edge (pair of two nodes) [https://en.wikipedia.org/wiki/Incidence_(graph)]
    # NOTE: an edge is defined by an incidence-relation, having max. a pair of two nodes: e=(vx,vy) => |e| <= 2 / implies vx==vy
    # DEF: a vertex is incident to an edge if the vertex is one of the two vertices the edge connects.
    # An incidence is given, iff the given :node exists and the other node from edge-definition exists too
    # An :edge is incident with a :node, if a :node specified by :edge has a direct connection to another :node
    # An :edge is incident with a :node, if a :node specified by :edge has a direct connection to the same given :node
    # In lastly case: another :node is equals :node => (v1 == v1)
    def incident?(node, edge)
      node = key_for(node)
      edge = keyify(edge)

      raise InvalidEdge unless valid_edge_definition?(edge)

      return false unless node?(node) # Not possible if node is unknown
      return false unless known?(*edge) # Not possible, if edge-definition does not contain known nodes

      #other_node = edge.without(node) # FIXME: undefined method `without' for [:a, :b]:Array" #ActiveSupport #1
      edge.delete(node)
      other_node = edge.first if edge.one? # Must be after calling delete on edge

      neighbors(node).include?(other_node)
    end

    # Detects if a :node is connected with itself or any :target is connected to :node by any egde-definition
    def circle?(origin, target = nil)0
      return true if self_circled?(origin) # Break if at least a circle exists with itself
      return false if target.nil?

      neighbors(key_for(target)).each do |node|
        # connected?(node, origin)

        #return if adjacent?(node, origin)
      end
    end

    def circled?
      # Vistit all nodes for detecing a circle
    end

    private def self_circled?(node)
      neighbors(node).include?(key_for(node))
    end
  end
end
