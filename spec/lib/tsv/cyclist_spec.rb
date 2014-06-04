require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe TSV::Cyclist do
  subject(:cyclist) { TSV::Cyclist.new(tsv_path, parameters) }
  let(:tsv_path) { File.join(File.dirname(__FILE__), '..', '..', 'fixtures', filename) }
  let(:filename) { 'example.tsv' }

  let(:header) { true }
  let(:parameters) { { header: header } }

  describe "::new" do
    it "initializes enumerator reader" do
      expect(subject.enumerator).to be_a_kind_of(Enumerator)
    end

    it "initializes header to true by default" do
      expect(subject.header).to be_true
    end

    it "initializes filepath to given value" do
      expect(subject.filepath).to eq(tsv_path)
    end

    context "when block is given" do
      it "passes block to enumerator through each" do
        block = lambda {}

        enumerator = double("enumerator")
        enumerator.should_receive(:each).with(&block)

        Enumerator.should_receive(:new).and_return(enumerator)

        TSV::Cyclist.new(tsv_path, &block)
      end
    end
  end

  describe "#with_header" do
    subject { cyclist.with_header }
    it "returns a Cyclist with header option set to true" do
      expect(subject.header).to be_true
    end
  end

  describe "#without_header" do
    subject { cyclist.without_header }

    it "returns a Cyclist with header option set to false" do
      expect(subject.header).to be_false
    end
  end

  describe "enumerator interfaces" do
    ( Enumerable.instance_methods(false) + Enumerator.instance_methods(false) ).each do |name|
      it "delegates #{name} to enumerator" do
        expect(subject.enumerator).to receive(name)
        subject.send(name)
      end
    end
  end

  describe "accessing unavailable files" do
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
