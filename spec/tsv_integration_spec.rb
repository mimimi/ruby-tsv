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
        context "when requested without header" do
          let(:header) { false }
          let(:auto_header) { %w{0 1 2} }

          it "returns its content as array of arrays" do
            expect(subject).to eq [ TSV::Row.new( ['first', 'second', 'third'], auto_header ),
                                    TSV::Row.new( ['0', '1', '2'], auto_header ),
                                    TSV::Row.new( ['one', 'two', 'three'], auto_header ),
                                    TSV::Row.new( ['weird data', 's@mthin#', 'else'], auto_header ) ]
          end
        end

        context "when requested with header" do
          let(:header) { true }

          it "returns its content as array of hashes" do
            headers = %w{first second third}
            expect(subject).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                    TSV::Row.new( ['one', 'two', 'three'], headers ),
                                    TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
          end
        end

        context "when requested without specifying header option" do
          let(:parameters) { Hash.new }

          it "returns its content as array of hashes" do
            headers = %w{first second third}
            expect(subject).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                    TSV::Row.new( ['one', 'two', 'three'], headers ),
                                    TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
          end
        end
      end

      context "when block is passed"
    end
  end

  describe "reading from string" do
    context "when string is empty"
    context "when string is invalid"
    context "when string is valid"
  end
end