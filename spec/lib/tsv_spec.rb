require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TSV do
  describe "#parse" do
    let(:header) { nil }
    let(:tsv_path) { File.join(File.dirname(__FILE__), '..', 'fixtures', filename) }
    let(:parameters) { { header: header } }

    subject { TSV.parse(tsv_path, parameters) }

    describe "edge cases" do
      subject { lambda { TSV.parse(tsv_path) } }

      context "when file is not found" do
        let(:tsv_path) { "AManThatWasntThere.tsv" }

        it "returns FileNotFoundException" do
          expect(subject).to raise_error(Errno::ENOENT)
        end
      end

      context "when filename is invalid" do
        let(:tsv_path) { nil }

        it "returns FileNameInvalidException" do
          expect(subject).to raise_error(TSV::FileNameInvalidException)
        end
      end
    end

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

    context "when file is valid" do
      let(:filename) { 'example.tsv' }

      context "when no block is passed" do
        context "when requested without header" do
          let(:header) { false }

          it "returns its content as array of arrays" do
            expect(subject).to eq [ TSV::Row.new( ['first', 'second', 'third'] ),
                                    TSV::Row.new( ['0', '1', '2'] ),
                                    TSV::Row.new( ['one', 'two', 'three'] ),
                                    TSV::Row.new( ['weird data', 's@mthin#', 'else'] ) ]
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

      context "when block is passed" do
      end
    end
  end
end
