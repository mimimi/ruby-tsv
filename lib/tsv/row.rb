module TSV
  class Row
    attr_accessor :header, :data

    def []=(key, value)
      raise TSV::ReadOnly.new('TSV data is read only. Export data to modify it.')
    end

    def [](key)
      if key.is_a? ::String
        raise UnknownKey unless header.include?(key)

        data[header.index(key)]
      elsif key.is_a? ::Numeric
        raise UnknownKey if data[key].nil?

        data[key]
      else
        raise InvalidKey.new
      end
    end

    def initialize(data, header = nil)
      @data = data
      @header = header || (0...data.length).to_a.map(&:to_s)

      raise InputError if @data.length != @header.length
    end

    class InvalidKey < StandardError
    end

    class UnknownKey < StandardError
    end

    class InputError < StandardError
    end
  end
end