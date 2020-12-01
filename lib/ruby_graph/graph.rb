module RubyGraph
  class Graph
    attr_reader :name, :storage

    def self.build(name: nil)
      new(name)
    end

    def initialize(name = nil)
      @name = name || object_id
      @storage = {}
    end

    # Returns true if graph has no nodes
    def empty?
      @storage.empty?
    end

    # Responds if a node is known
    def node?(name)
      @storage.key?(node_key_for(name))
    end

    # Returns the node-definition
    # Currently the same as :neighbors
    def node(name)
      @storage[node_key_for(name)]
    end

    def nodes
      @storage.keys
    end

    # [%i[a b], %i[a c]]
    def edges
      result = []
      return result if empty?

      @storage.each do |node, neighbors|
        neighbors.each do |neighbor|
          result << [node, neighbor].sort
        end
      end

      result.uniq
    end

    # Returns all neighbors of a node
    def neighbors(name)
      @storage[node_key_for(name)]
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

      @storage[source] << target
      @storage[target] << source unless source.eql?(target)
      true
    end

    private def add_node(name)
      @storage[node_key_for(name)] = []
    end

    private def node_key_for(name)
      name.to_s.to_sym
    end
  end
end
