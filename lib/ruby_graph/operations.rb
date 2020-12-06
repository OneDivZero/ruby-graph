module RubyGraph
  module Operations
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
  end
end
