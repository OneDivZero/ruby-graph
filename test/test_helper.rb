$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

ENV['RAILS_ENV'] ||= 'test'

INCLUDED_TEST_DIRS = %w[support].freeze
GEM_FILE_PATH = File.dirname(__dir__)

require 'ruby_graph'

require 'minitest/autorun'
require 'minitest/focus'

INCLUDED_TEST_DIRS.each do |folder|
  file_list_pattern = [GEM_FILE_PATH, 'test', folder, '**', '*.rb'].join('/')
  Dir[file_list_pattern].sort.each { |f| require f }
end
