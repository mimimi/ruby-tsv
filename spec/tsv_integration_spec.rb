require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe TSV do
  let(:header) { nil }
  let(:tsv_path) { File.join(File.dirname(__FILE__), 'fixtures', filename) }
  let(:parameters) { { header: header } }

  describe "reading file" do
    subject { TSV.parse_file(tsv_path, parameters).to_a }

    context "when file is empty" do
      let(:filename) { 'empty.tsv' }

      context "when requested without header" do
        let(:header) { true }

        it { expect(subject).to be_empty }
      end

      context "when requested with header" do
        let(:header) { false }

        it { expect(subject).to be_empty }
      end
    end

    context "when file is invalid" do
      subject { lambda { TSV.parse_file(tsv_path, parameters).to_a } }
      let(:filename) { 'broken.tsv' }

      it "when file is broken" do
        expect(subject).to raise_error TSV::Row::InputError
      end
    end

    context "when file is valid" do
      let(:filename) { 'example.tsv' }

      context "when no block is passed" do
        let(:parameters) { Hash.new }

        it "returns its content as array of hashes" do
          headers = %w{first second third}
          expect(subject).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                  TSV::Row.new( ['one', 'two', 'three'], headers ),
                                  TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
        end
      end
    end

    context "when file includes empty trailing fields" do
      let(:filename) { 'empty-trailing.tsv' }

      context "when no block is passed" do
        let(:parameters) { Hash.new }

        it "returns its content as array of hashes" do
          headers = %w{first second third}
          expect(subject).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                  TSV::Row.new( ['one', '', ''], headers ) ]
        end
      end
    end
  end

  describe "reading from string" do
    subject { TSV.parse(IO.read(tsv_path), parameters).to_a }

    context "when string is empty"  do
      let(:filename) { 'empty.tsv' }

      context "when requested without header" do
        let(:header) { true }

        it { expect(subject).to be_empty }
      end

      context "when requested with header" do
        let(:header) { false }

        it { expect(subject).to be_empty }
      end
    end

    context "when string is invalid" do
      subject { lambda { TSV.parse(IO.read(tsv_path), parameters).to_a } }
      let(:filename) { 'broken.tsv' }

      it "when file is broken" do
        expect(subject).to raise_error TSV::Row::InputError
      end
    end

    context "when string is valid" do
      let(:filename) { 'example.tsv' }

      context "when no block is passed" do
        let(:parameters) { Hash.new }

        it "returns its content as array of hashes" do
          headers = %w{first second third}
          expect(subject).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                  TSV::Row.new( ['one', 'two', 'three'], headers ),
                                  TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
        end
      end
    end
  end
end
