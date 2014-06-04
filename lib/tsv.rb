require "tsv/version"
require "tsv/row"
require "tsv/cyclist"
require 'active_support/core_ext/hash'

module TSV
  extend self
  
  def parse_file(filename, opts = {}, &block)
    TSV::FileCyclist.new(filename, opts, &block)
  end

  alias :[] :parse_file

  class ReadOnly < StandardError
  end
end
