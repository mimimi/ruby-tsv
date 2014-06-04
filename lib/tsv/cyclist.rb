module TSV
  class Cyclist
    extend Forwardable

    def_delegators :@enumerator, *Enumerator.instance_methods(false)
    def_delegators :@enumerator, *Enumerable.instance_methods(false)

    attr_accessor :filepath, :header, :enumerator

    def initialize(filepath, params = {}, &block)
      self.header   = params.fetch(:header, true)
      self.filepath = filepath.to_s

      self.enumerator = ::Enumerator.new do |y|
        open(self.filepath, 'r') do |f|
          first_line = (f.gets || "").chomp.split("\t")

          if !self.header && first_line.any?
            header = (0...first_line.length).to_a.map(&:to_s)
            y << TSV::Row.new(first_line, header)
          else
            header = first_line
          end

          loop do
            line = f.gets
            break if line.nil?

            y << TSV::Row.new(line.chomp.split("\t"), header)
          end
        end
      end

      self.enumerator.each(&block) if block_given?
    end

    def with_header
      self.class.new(@filepath, header: true)
    end

    def without_header
      self.class.new(@filepath, header: false)
    end
  end
end
