require "tsv/version"
require "tsv/row"
require "tsv/cyclist"
require 'active_support/core_ext/hash'

module TSV
  extend self

  def parse(filepath, opts = {})
    TSV::Cyclist.new(filepath, opts).to_a
  end

  def [](filename)
    TSV::Cyclist.new(filename)
  end

  class ReadOnly < StandardError
  end
end
