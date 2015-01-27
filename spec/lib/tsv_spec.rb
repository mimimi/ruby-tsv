require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TSV do
  let(:filename) { 'example.tsv' }

  describe "#parse" do
    let(:header) { nil }
    let(:parameters) { { header: header } }

    context "given a string with content" do
      let(:content) { IO.read(File.join(File.dirname(__FILE__), '..', 'fixtures', filename)) }

      subject { TSV.parse(content, parameters) }

      it "returns String Cyclist initialized with given data" do
        expect(subject).to be_a TSV::LineCyclist
        expect(subject.source).to eq(content)
      end

      context "when block is given" do
        it "passes block to Cyclist" do
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

      it "returns String Cyclist initialized with given data" do
        expect(subject).to be_a TSV::LineCyclist
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

    it "returns Cyclist object initialized with given filepath" do
      expect(subject).to be_a TSV::FileCyclist
      expect(subject.filepath).to eq tsv_path
    end

    context "when block is given" do
      it "passes block to Cyclist" do
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
  end
end
