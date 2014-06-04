shared_examples_for "Cyclist" do
  describe "::new" do
    it "initializes header to true by default" do
      expect(subject.header).to be_true
    end

    it "initializes source to given value" do
      expect(subject.source).to eq(tsv_path)
    end

    context "when block is given" do
      it "passes block to enumerator through each" do
        block = lambda {}

        enumerator = double("enumerator")
        enumerator.should_receive(:each).with(&block)

        Enumerator.should_receive(:new).and_return(enumerator)

        subject_class.new(tsv_path, &block)
      end
    end
  end

  describe "#enumerator" do
    it { expect(cyclist.enumerator).to be_a_kind_of(Enumerator) }
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
        expect(cyclist.enumerator).to receive(name)
        cyclist.send(name)
      end
    end
  end
end