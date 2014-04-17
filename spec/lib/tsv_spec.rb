require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TSV do
  describe "#parse" do
    subject { lambda { TSV.parse(filename) } }

    context "when file is not found" do
      let(:filename) { "AManThatWasntThere.tsv" }

      it "returns FileNotFoundException" do
        expect(subject).to raise_error(Errno::ENOENT)
      end
    end

    context "when filename is invalid" do
      let(:filename) { nil }

      it "returns FileNameInvalidException" do
        expect(subject).to raise_error(TSV::FileNameInvalidException)
      end
    end
  end
end
