module RubyGraph
  module TestMethods
    def build_graph(name: nil, with: [])
      @graph = RubyGraph::Graph.build(name: name, with: with)
    end
  end
end
