require 'ruby_graph/accessors'
require 'ruby_graph/operations'
require 'ruby_graph/features'

# RubyGraph::Graph provides a simple graph-datastructure with a hash-based store.
# As of yet, it only supports undirected graphs and has a very simple, cost-inefficient underlying datastructure.
module RubyGraph
  class Graph
    include RubyGraph::Accessors
    include RubyGraph::Operations
    include RubyGraph::Features

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
