require "tsv/version"
require "tsv/row"
require "tsv/cyclist"
require 'active_support/core_ext/hash'

module TSV
  extend self

  def parse(filepath, opts = {})
    raise FileNameInvalidException if filepath.nil?

    get_header = opts.with_indifferent_access.fetch(:header, true)

    open(filepath, 'r') do |f|
      header = get_header ?  (f.gets || "").chomp.split("\t") : nil

      f.each_line.map do |line|
        TSV::Row.new line.chomp.split("\t"), header
      end
    end
  end

  def [](filename)
    TSV::Cyclist.new(filename)
  end

  class FileNameInvalidException < IOError
  end

  class ReadOnly < StandardError
  end
end
