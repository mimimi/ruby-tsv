module TSV
  class Row
    extend Forwardable

    def_delegators :data, *Enumerable.instance_methods(false)

    attr_reader :header, :data

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

    def initialize(data, header)
      @data = data
      @header = header

      raise InputError if @data.length != @header.length
    end

    def with_header
      Hash[header.zip(data)]
    end

    def ==(other)
      other.is_a?(self.class) and
        header == other.header and
        data == other.data
    end

    class InvalidKey < StandardError
    end

    class UnknownKey < StandardError
    end

    class InputError < StandardError
    end
  end
end
