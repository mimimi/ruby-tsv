module TSV
  class Table
    extend Forwardable

    def_delegators :enumerator, *Enumerator.instance_methods(false)
    def_delegators :enumerator, *Enumerable.instance_methods(false)

    attr_accessor :source, :header

    def initialize(source, params = {}, &block)
      self.header = params.fetch(:header, true)
      self.source = source
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

        first_line = generate_row_from begin
          lines.next
        rescue StopIteration => ex
          ''
        end

        local_header = if self.header
          first_line
        else
          lines.rewind
          generate_default_header_from first_line
        end

        loop do
          y << TSV::Row.new(generate_row_from(lines.next).freeze, local_header.freeze)
        end
      end
    end

    def data_enumerator
      source.each_line
    end

    protected

    def generate_row_from(str)
      str.to_s.chomp.split("\t", -1)
    end

    def generate_default_header_from(example_line)
      (0...example_line.length).to_a.map(&:to_s)
    end
  end
end
