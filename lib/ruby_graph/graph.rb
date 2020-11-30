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
  end
end
