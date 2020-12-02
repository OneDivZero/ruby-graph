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

      with.each { |name| add(name) } if with.any?
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
      @store[key_for(name)]
    end

    def nodes
      @store.keys
    end

    # Returns all edges
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

    # Evaluates if two nodes are directly connected (via one edge)
    def adjacent?(source, target)
      source = key_for(source)
      target = key_for(target)

      neighbors(source).include?(target)
    end

    # Evaluates if given node-list is known
    def known?(*nodes)
      # raise InvalidSet unless nodes.is_a?(Array)

      nodes.reduce(true) { |result, name| result && node?(name) }
    end

    # Evaluates if a given node is incident with a given edge (a pair of two nodes)
    # ein Knoten ist inzident mit einer Kante: der Knoten liegt an wenigstens einem Ende der Kante
    # eine Kante ist inzident mit einem Knoten: die Kante hat den Knoten an einem ihrer Enden
    # An incidence is given, if and only if the given :node exists and *all defined :nodes* from edge-definition exists
    # One :node is incident with an :edge, if the :node has a direct connection to another :node specified by :edge
    # One :edge is incident with a :node, if a :node specified by :edge has a direct connection to given :node
    def incident?(node, edge)
      node = key_for(node)
      edge = keyify(edge)

      raise InvalidEdge unless valid_edge?(edge)

      return false unless node?(node) # Not possible if node is unknown
      #return false unless edge.include?(node)
      return false unless known?(*edge) # Not possible, if edge-definition does not contain specified nodes

      #other_node = edge.without(node) # FIXME: undefined method `without' for [:a, :b]:Array" #ActiveSupport #1
      edge.delete(node)
      other_node = edge.first

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

    private def add_node(name)
      @store[key_for(name)] = []
    end

    private def key_for(name)
      raise InvalidNode unless valid_key?(name)
      # NOTE: DNW: cause a name with an integer-value like '0221' is converted upfront by ruby #1
      # And there is no way to detect this implicit conversion to an octal-representation. Thus: Remove that feature
      #name.is_a?(Integer) ? ('0%o' % name).to_sym : name.to_s.to_sym
      name.to_s.to_sym
    end

    private def valid_key?(name)
      name.is_a?(Symbol) || name.is_a?(String) || name.is_a?(Integer)
    end

    private def valid_edge?(edge)
      edge.is_a?(Array) && edge.size.eql?(2) && symbolized?(edge)
    end

    private def keyify(edge)
      raise InvalidEdge unless valid_edge?(edge)

      edge.map { |name| key_for(name) }
    end

    private def symbolized?(list)
      list.reduce(true) { |result, value| result && value.is_a?(Symbol) }
    end
  end
end
