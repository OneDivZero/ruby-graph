module RubyGraph
  module TestMethods
    def build_graph(name: nil)
      @graph = RubyGraph::Graph.build(name: name)
    end
  end
end
