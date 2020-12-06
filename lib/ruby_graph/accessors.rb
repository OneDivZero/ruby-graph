module RubyGraph
  module Accessors
    # Returns a node-definition for given name (currently the same as :neighbors) #1
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
  end
end
