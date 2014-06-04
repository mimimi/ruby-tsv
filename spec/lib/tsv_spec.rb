require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TSV do
  describe "#parse" do
    let(:header) { nil }
    let(:content) { IO.read(File.dirname(__FILE__), '..', 'fixtures', filename) }
    let(:parameters) { { header: header } }

    subject { TSV.parse(content, parameters) }

    it "returns String Cyclist initialized with given data"
  end

  describe "#parse_file" do
    let(:tsv_path) { File.join(File.dirname(__FILE__), '..', 'fixtures', filename) }
    let(:filename) { 'example.tsv' }

    subject { TSV.parse_file tsv_path }

    it "returns Cyclist object initialized with given filepath" do
      expect(subject).to be_a TSV::FileCyclist
      expect(subject.filepath).to eq tsv_path
    end

    context "when block is given" do
      let(:block) { lambda { } }

      it "passes block to Cyclist" do
        TSV::FileCyclist.should_receive(:new).with(tsv_path, {}, &block)

        TSV.parse_file(tsv_path, &block)
      end
    end
  end
end
