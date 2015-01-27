require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TSV do
  let(:filename) { 'example.tsv' }

  describe "#parse" do
    let(:header) { nil }
    let(:parameters) { { header: header } }

    context "given a string with content" do
      let(:content) { IO.read(File.join(File.dirname(__FILE__), '..', 'fixtures', filename)) }

      subject { TSV.parse(content, parameters) }

      it "returns Table initialized with given data" do
        expect(subject).to be_a TSV::Table
        expect(subject.source).to eq(content)
      end

      context "when block is given" do
        it "passes block to Table" do
          data = []

          TSV.parse(content) do |i|
            data.push i
          end

          headers = %w{first second third}
          expect(data).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                               TSV::Row.new( ['one', 'two', 'three'], headers ),
                               TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
        end
      end
    end

    context "given a opened IO object" do
      let(:content) { File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', filename), 'r') }

      subject { TSV.parse(content, parameters) }

      it "returns Table initialized with given data" do
        expect(subject).to be_a TSV::Table
        expect(subject.source).to eq(content)
      end

      it "can properly parse file" do
        data = []

        TSV.parse(content).each do |i|
          data.push i
        end

        headers = %w{first second third}
        expect(data).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                             TSV::Row.new( ['one', 'two', 'three'], headers ),
                             TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
      end
    end
  end

  describe "#parse_file" do
    let(:tsv_path) { File.join(File.dirname(__FILE__), '..', 'fixtures', filename) }

    subject { TSV.parse_file tsv_path }

    context "when no block is given" do
      it "returns Table initialized with File object" do
        expect(subject).to be_a TSV::Table
        expect(subject.source).to be_kind_of(File)
        expect(subject.source.path).to eq(tsv_path)
      end
    end

    context "when block is given" do
      it "passes block to Table" do
        data = []

        TSV.parse_file(tsv_path) do |i|
          data.push i
        end

        headers = %w{first second third}
        expect(data).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                TSV::Row.new( ['one', 'two', 'three'], headers ),
                                TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
      end
    end

    context "when accessing unavailable files" do
      subject { lambda { TSV.parse_file(tsv_path).to_a } }

      context "when file is not found" do
        let(:tsv_path) { "AManThatWasntThere.tsv" }

        it "returns FileNotFoundException" do
          expect(subject).to raise_error(Errno::ENOENT)
        end
      end
    end

    describe "intermediate file handle" do
      it "raises IOError on write attempt" do
        tempfile = Tempfile.new('tsv_test')
        handle = TSV.parse_file(tempfile.path).source

        expect{ handle.puts('test string please ignore') }.to raise_error(IOError, 'not opened for writing')
      end
    end

  end
end
