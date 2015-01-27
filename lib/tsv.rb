require 'forwardable'

require "tsv/version"
require "tsv/row"
require "tsv/table"

module TSV
  extend self

  def parse(content, opts = {}, &block)
    TSV::Table.new(content, opts, &block)
  end

  def parse_file(filename, opts = {}, &block)
    TSV::Table.new(File.new(filename, 'r'), opts, &block)
  end

  alias :[] :parse_file

  class ReadOnly < StandardError
  end
end
