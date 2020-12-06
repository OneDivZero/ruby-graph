# RubyGraph::Graph provides a simple graph-datastructure with a hash-based store.
# As of yet, it only supports undirected graphs and has a very simple, cost-inefficient underlying datastructure.
module RubyGraph
  class Graph
    class InvalidNode < StandardError; end

    class InvalidEdge < StandardError; end
    # class InvalidSet < StandardError; end

    attr_reader :name, :store

    # TODO: Accept an edge-definition to, such that G=(V,E), rename :with to :nodes and add :edges (array of arrays)
    def self.build(name: nil, with: [])
      new(name, with: with)
    end

    def initialize(name = nil, with: [])
      @name = name || object_id
      @store = {}

      with.each { |node_key| add(node_key) } if with.any?
    end

    # Returns true if graph has no nodes
    def empty?
      @store.empty?
    end

    # Evaluates if a node is known
    def node?(name)
      @store.key?(key_for(name))
    end

    # Returns the node-definition
    # Currently the same as :neighbors
    def node(name)
      #@store[key_for(name)]
      neighbors(name)
    end

    # Returns all added nodes
    def nodes
      @store.keys
    end

    # Returns all defined (implicit) edges
    def edges
      result = []
      return result if empty?

      @store.each do |node, neighbors|
        neighbors.each do |neighbor|
          result << [node, neighbor].sort
        end
      end

      result.uniq
    end

    # Returns all neighbors of a node
    def neighbors(name)
      @store[key_for(name)]
    end

    # Evaluates if two nodes are directly connected (via an implicit edge)
    def adjacent?(source, target)
      source = key_for(source)
      target = key_for(target)

      neighbors(source).include?(target)
    end

    # Evaluates if given node-list is known
    def known?(*nodes)
      nodes.reduce(true) { |result, name| result && node?(name) }
    end

    # Evaluates if a given node is incident with a given edge (a pair of two nodes)
    # An incidence is given, if and only if the given :node exists and *all defined :nodes* from edge-definition exists
    # One :node is incident with an :edge, if the :node has a direct connection to another :node specified by :edge
    # One :edge is incident with a :node, if a :node specified by :edge has a direct connection to given :node
    def incident?(node, edge)
      node = key_for(node)
      edge = keyify(edge)

      raise InvalidEdge unless valid_edge?(edge)

      return false unless node?(node) # Not possible if node is unknown
      return false unless known?(*edge) # Not possible, if edge-definition does not contain known nodes

      #other_node = edge.without(node) # FIXME: undefined method `without' for [:a, :b]:Array" #ActiveSupport #1
      edge.delete(node)
      other_node = edge.first if edge.one? # Must be after calling delete on edge

      neighbors(node).include?(other_node)
    end

    # Adds a new node to graph, unless it already exists
    # Connects it to another node, if a target named :to is present
    # TODO: DOCME: integers with a leading zero like phone-numbers will always be converted by ruby, e.g. 0221 => 145
    def add(name, to: nil)
      add_node(name) unless node?(name)

      return true unless to.present?
      return false unless node?(to)

      connect(name, to)
    end

    # Removes a node including all edges to neighbors
    def remove(name)
      return false unless node?(name)

      neighbors(name).each do |neighbor|
        node(neighbor).delete(name)
      end

      @store.delete(:a)
    end

    # Connects to nodes
    def connect(source, target)
      source = key_for(source)
      target = key_for(target)

      return false unless node?(source)
      return false unless node?(target)

      @store[source] << target
      @store[target] << source unless source.eql?(target)
      true
    end

    # Adds a node with given name to internal store. Converts the name upfront to a valid symbol.
    private def add_node(name)
      @store[key_for(name)] = []
    end

    private def key_for(name)
      raise InvalidNode unless valid_key?(name)

      name.to_s.to_sym
    end

    # Ensures if a given name is strictly a [Symbol, String, Integer]
    private def valid_key?(name)
      name.is_a?(Symbol) || name.is_a?(String) || name.is_a?(Integer)
    end

    # Ensures if a given edge-definition is valid (valid: if it's a symbolized two-element-array)
    private def valid_edge_definition?(edge, symbolized: true)
      proof = edge.is_a?(Array) && edge.size.eql?(2)
      proof &= symbolized?(edge) if symbolized
      proof
    end

    # Transforms every designator of an edge into a valid symbolized designator
    private def keyify(edge)
      raise InvalidEdge unless valid_edge_definition?(edge, symbolized: false)

      edge.map { |name| key_for(name) }
    end

    private def symbolized?(list)
      list.reduce(true) { |result, value| result && value.is_a?(Symbol) }
    end
  end
end
