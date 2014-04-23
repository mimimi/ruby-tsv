require "tsv/version"
require "tsv/row"
require 'active_support/core_ext/hash'

module TSV
  extend self

  def parse(filepath, opts = {})
    raise FileNameInvalidException if filepath.nil?

    get_header = opts.with_indifferent_access.fetch(:header, true)

    open(filepath, 'r') do |f|
      if get_header
        header = (f.gets || "").chomp.split("\t")

        f.each_line.map do |line|
          intermediate = line.chomp.split("\t").each_with_index.map do |val, i|
            [header[i], val]
          end

          Hash[intermediate]
        end
      else
        f.each_line.map { |line| line.chomp.split("\t") }
      end
    end
  end

  class FileNameInvalidException < IOError
  end

  class ReadOnly < StandardError
  end
end
