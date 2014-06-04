require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe TSV::FileCyclist do
  let(:tsv_path) { File.join(File.dirname(__FILE__), '..', '..', 'fixtures', filename) }
  let(:source)   { tsv_path }
  let(:filename) { 'example.tsv' }

  let(:header) { true }
  let(:parameters) { { header: header } }

  subject(:cyclist) { TSV::FileCyclist.new(source, parameters) }

  it_behaves_like "Cyclist"

  describe "accessing unavailable files" do
    subject { lambda { TSV::FileCyclist.new(tsv_path).to_a } }

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
