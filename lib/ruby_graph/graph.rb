module RubyGraph
  class Graph
    attr_reader :name, :store

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

    # Responds if a node is known
    def node?(name)
      @store.key?(node_key_for(name))
    end

    # Returns the node-definition
    # Currently the same as :neighbors
    def node(name)
      @store[node_key_for(name)]
    end

    def nodes
      @store.keys
    end

    # [%i[a b], %i[a c]]
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
      @store[node_key_for(name)]
    end

    # Responds if two nodes are directly connected (via one edge)
    def adjacent?(source, target)
      neighbors(source).include?(target)
    end

    # Adds a new node to graph, unless it already exists
    # Connects it to another node, if a target named :to is present
    # DOCME: integers with a leading zero like phone-numbers will always be converted by ruby, e.g. 0221 => 145
    def add(name, to: nil)
      add_node(name) unless node?(name)

      return true unless to.present?
      return false unless node?(to)

      connect(name, to)
    end

    # Connects to nodes
    def connect(source, target)
      source = node_key_for(source)
      target = node_key_for(target)

      return false unless node?(source)
      return false unless node?(target)

      @store[source] << target
      @store[target] << source unless source.eql?(target)
      true
    end

    private def add_node(name)
      @store[node_key_for(name)] = []
    end

    private def node_key_for(name)
      name.to_s.to_sym
    end
  end
end
