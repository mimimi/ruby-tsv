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

    protected

    def generate_row_from(str)
      str.to_s.chomp.split("\t")
    end

    def generate_default_header_from(example_line)
      (0...example_line.length).to_a.map(&:to_s)
    end
  end

  class FileCyclist < Cyclist
    alias :filepath :source

    def enumerator
      @enumerator ||= ::Enumerator.new do |y|
        open(self.source, 'r') do |f|
          first_line = generate_row_from(f.gets)

          header = first_line

          !self.header and
            first_line.any? and
            header = generate_default_header_from(first_line) and
            y << TSV::Row.new(first_line, header)

          loop do
            line = f.gets
            break if line.nil?

            y << TSV::Row.new(generate_row_from(line), header)
          end
        end
      end
    end
  end

  class StringCyclist < Cyclist
    def enumerator
      @enumerator ||= ::Enumerator.new do |y|
        lines = source.split("\n")

        first_line = generate_row_from lines.shift

        header = first_line

        !self.header and
          first_line.any? and
          header = generate_default_header_from(first_line) and
          y << TSV::Row.new(first_line, header)

        loop do
          line = lines.shift
          break if line.nil?

          y << TSV::Row.new(generate_row_from(line), header)
        end
      end
    end
  end
end
