module RubyGraph
  module Features
    # Returns true if graph has no nodes
    def empty?
      @store.empty?
    end

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

    # Evaluates if a given node is incident with a given edge (a pair of two nodes)
    # An incidence is given, if and only if the given :node exists and *all defined :nodes* from edge-definition exists
    # One :node is incident with an :edge, if the :node has a direct connection to another :node specified by :edge
    # One :edge is incident with a :node, if a :node specified by :edge has a direct connection to given :node
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

    # Detects if a node is connected with itself
    # TODO: Missing arg: :target, requires detection of a circle between :origin and :target
    def circle?(origin)
      origin = key_for(origin)

      return true if neighbors(origin).include?(origin)
    end
  end
end
