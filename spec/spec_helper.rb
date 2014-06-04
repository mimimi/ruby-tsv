require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'rspec'

require 'tsv'

# Disabling old rspec should syntax
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}