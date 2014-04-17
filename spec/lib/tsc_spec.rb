require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TSV do
  describe "#parse" do
    context "when file is not found" do
      subject { TSV.parse("AManThatWasntThere.tsv") }

      it "returns FileNotFoundException" do
        expect(subject).to raise_error(FileNotFoundException)
      end
    end

    context "when filename is nil" do
      subject { TSV.parse(nil) }

      it "returns FileNameInvalidException" do
        expect(subject).to raise_error(FileNameInvalidException)
      end
    end
  end
end
