module TSV
  class Cyclist
    extend Forwardable

    def_delegators :@enumerator, *Enumerator.instance_methods
    attr_accessor :filepath, :with_header

    def initialize(filepath, params = {})
      raise FileNameInvalidException if filepath.nil?

      self.with_header = params.fetch(:with_header, true)

      self.filepath = filepath

      @enumerator = ::Enumerator.new do |y|
        open(filepath, 'r') do |f|
          header = self.with_header ?  (f.gets || "").chomp.split("\t") : nil

          loop do
            line = f.gets
            break if line.nil?

            y << TSV::Row.new(line.chomp.split("\t"), header)
          end
        end
      end
    end

    def with_header
      new_params = params.dup
      new_params[:with_header] = true

      self.class.new(@filename, new_params)
    end

    def without_header
      new_params = params.dup
      new_params[:with_header] = false

      self.class.new(@filename, new_params)
    end
  end
end
