require 'test_helper'

class RubyGraphTest < RubyGraph::SpecTest
  describe 'Versioning' do
    it 'has a version' do
      RubyGraph.const_defined? 'VERSION'
      assert_not_nil RubyGraph::VERSION
    end

    it 'has a fixed current version' do
      assert_equal '0.1.0-alpha', RubyGraph::VERSION
    end

    it "has a changelog-file for version: #{RubyGraph::VERSION}" do
      assert File.exist?(".changelog/#{RubyGraph::VERSION}.md")
    end
  end

  describe 'Building a graph' do
    it 'can build a graph' do
      assert_instance_of RubyGraph::Graph, RubyGraph.build
    end
  end
end
