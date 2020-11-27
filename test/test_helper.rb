$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

ENV['RAILS_ENV'] ||= 'test'

INCLUDED_TEST_DIRS = %w[support].freeze

require 'ruby_graph'

require 'minitest/autorun'
require 'minitest/focus'

INCLUDED_TEST_DIRS.each do |folder|
  Dir[[File.dirname(__dir__), 'test', folder, '**', '*.rb'].join('/')].sort.each { |f| require f }
end
