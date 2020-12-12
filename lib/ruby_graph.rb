require 'ruby_graph/version'
require 'ruby_graph/graph'
# require 'ruby_graph/features'

module RubyGraph
  def self.build(name = nil, with: [])
    Graph.build(name: name, with: with)
  end
end
