require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe TSV::Cyclist do
  describe "::new" do
    let(:tsv_path) { File.join(File.dirname(__FILE__), '..', '..', 'fixtures', filename) }
    let(:filename) { 'example.tsv' }

    let(:header) { true }
    let(:parameters) { { header: header } }

    subject { TSV::Cyclist.new(tsv_path, parameters) }

    it "works as a fucking enumerator" do
      headers = %w{first second third}

      expect(subject.take(10)).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                       TSV::Row.new( ['one', 'two', 'three'], headers ),
                                       TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
    end

    describe "reading unavailable files" do
      subject { lambda { TSV::Cyclist.new(tsv_path).to_a } }

      context "when file is not found" do
        let(:tsv_path) { "AManThatWasntThere.tsv" }

        it "returns FileNotFoundException" do
          expect(subject).to raise_error(Errno::ENOENT)
        end
      end

      context "when filename is nil" do
        let(:tsv_path) { nil }

        it "returns FileNameInvalidException" do
          expect(subject).to raise_error(Errno::ENOENT)
        end
      end
    end
  end
end
