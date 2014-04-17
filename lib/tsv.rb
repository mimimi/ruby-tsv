require "tsv/version"

module TSV
  extend self

  def parse(filepath, opts = {})
    raise FileNameInvalidException if filepath.nil?

    res = []

    open(filepath, 'r') do |f|
      f.each_line do |line|
        res.push line.chomp.split("\t")
      end
    end

    res
  end

  class FileNameInvalidException < IOError
  end
end
