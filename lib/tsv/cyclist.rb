module TSV
  class Cyclist
    extend Forwardable

    def_delegators :enumerator, *Enumerator.instance_methods(false)
    def_delegators :enumerator, *Enumerable.instance_methods(false)

    attr_accessor :source, :header

    def initialize(source, params = {}, &block)
      self.header   = params.fetch(:header, true)
      self.source = source.to_s
      self.enumerator.each(&block) if block_given?
    end

    def with_header
      self.class.new(self.source, header: true)
    end

    def without_header
      self.class.new(self.source, header: false)
    end

    def enumerator
      @enumerator ||= ::Enumerator.new do |y|
        lines = data_enumerator

        first_line = begin
          lines.next
        rescue StopIteration => ex
          ''
        end

        generate_header(y, first_line)

        loop do
          push_row_to y, lines.next
        end
      end
    end

    protected

    def generate_row_from(str)
      str.to_s.chomp.split("\t")
    end

    def generate_default_header_from(example_line)
      (0...example_line.length).to_a.map(&:to_s)
    end

    def push_row_to(y, line)
      y << TSV::Row.new(line.is_a?(Array) ? line : generate_row_from(line), @active_header)
    end

    def generate_header(y, first_line)
      @active_header = first_line = generate_row_from(first_line)

      !self.header and
        first_line.any? and
        @active_header = generate_default_header_from(first_line) and
        push_row_to(y, first_line)
    end
  end

  class FileCyclist < Cyclist
    alias :filepath :source

    def data_enumerator
      File.new(self.source).each_line
    end
  end

  class StringCyclist < Cyclist
    def data_enumerator
      source.each_line
    end
  end
end
