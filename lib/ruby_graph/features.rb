module RubyGraph
  module Features
    # Evaluates if a node is known
    def node?(name)
      @store.key?(key_for(name))
    end

    # Evaluates if given node-list is known
    def known?(*nodes)
      nodes.reduce(true) { |result, name| result && name.present? && node?(name) }
    end

    # TODO: NOT an alias for connection between nodes, cause this must be a generic graph-method
    def connected?(); end

    # Evaluates if two nodes are directly connected (via an implicit edge)
    # ∃e ∈ E : γ(e) = {a, b}
    def adjacent?(source, target)
      source = key_for(source)
      target = key_for(target)

      return false unless known?(source, target)

      neighbors(source).include?(target)
    end

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
      return false unless edge.include?(node) # Not possible, if node is not part of edge-definition

      other_node = edge.dup.without(node)
      neighbors(node).include?(*other_node)
    end

    # An edge is called a loop, if this edge is only incident to one node (e.g. edge = {a, a})
    def loop?(edge)
      edge = keyify(edge)

      raise InvalidEdge unless valid_edge_definition?(edge)

      return false unless known?(*edge)

      edge.first.eql?(edge.last)
    end

    # NOTE: Disabled for now, cause we need to implement other methods first
    # Detects if a :node is connected with itself or any other if :target is connected to :node by any egde-definition
    # def circle?(origin, target = nil)
    #   return false unless known?(origin)
    #   return true if self_circled?(origin) # Break if at least a circle exists with itself
    #   return false if target.nil? # If targit is nil, then there is no circle
    #   return false unless known?(target)

    #   neighbors(key_for(target)).each do |node|
    #     return true if adjacent?(node, origin)
    #   end
    # end

    # def circled?
    #   # Vistit all nodes for detecing a circle
    #   result = true
    #   nodes.each do |node, neighbors|
    #     return true if adjacent?(node, node)
    #     # true if niefhbors node are reachable to node with a back-reference
    #     # return true if neighbors
    #     neighbors(neighbors).each do |a_neighbor|
    #       return true if adjacent?(a_neighbor, node)
    #     end
    #   end

    #   false
    # end

    # private def self_circled?(node)
    #   neighbors(node).include?(key_for(node))
    # end
  end
end
