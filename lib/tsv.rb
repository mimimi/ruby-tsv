require "tsv/version"

module TSV
  extend self

  def parse(filepath)
    raise FileNameInvalidException if filepath.nil?

    open(filepath, 'r')
  end

  class FileNameInvalidException < IOError
  end
end
