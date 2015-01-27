require 'forwardable'

require "tsv/version"
require "tsv/row"
require "tsv/cyclist"

module TSV
  extend self

  def parse(content, opts = {}, &block)
    TSV::LineCyclist.new(content, opts, &block)
  end

  def parse_file(filename, opts = {}, &block)
    TSV::FileCyclist.new(filename, opts, &block)
  end

  alias :[] :parse_file

  class ReadOnly < StandardError
  end
end
