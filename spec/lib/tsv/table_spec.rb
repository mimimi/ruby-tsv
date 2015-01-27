require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe TSV::Table do
  let(:source) { IO.read(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', filename)) }
  let(:filename) { 'example.tsv' }

  let(:header) { true }
  let(:parameters) { { header: header } }

  subject(:table) { TSV::Table.new(source, parameters) }

  describe "::new" do
    it "initializes header to true by default" do
      expect(subject.header).to be true
    end

    it "initializes source to given value" do
      expect(subject.source).to eq(source)
    end

    context "when block is given" do
      it "passes block to enumerator through each" do
        data = []

        described_class.new(source) do |v|
          data << v
        end

        headers = %w{first second third}
        expect(data).to eq [ TSV::Row.new( ['0', '1', '2'], headers ),
                                TSV::Row.new( ['one', 'two', 'three'], headers ),
                                TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers ) ]
      end
    end
  end

  describe "#enumerator" do
    it { expect(table.enumerator).to be_a_kind_of(Enumerator) }
    subject { table.enumerator.to_a }

    context "string is empty" do
      let(:filename) { 'empty.tsv' }

      it { should be_empty }
    end

    context "string is incorrect" do
      let(:filename) { 'broken.tsv' }

      it "should raise exception" do
        expect { subject }.to raise_error(TSV::Row::InputError)
      end
    end

    context "string is correct" do
      context "when requested without header" do
        let(:header) { false }
        let(:auto_header) { %w{0 1 2} }

        it "returns its content as array of arrays" do
          expect(subject).to eq [ TSV::Row.new( ['first', 'second', 'third'], auto_header ),
                                  TSV::Row.new( ['0', '1', '2'], auto_header ),
                                  TSV::Row.new( ['one', 'two', 'three'], auto_header ),
                                  TSV::Row.new( ['weird data', 's@mthin#', 'else'], auto_header ) ]
        end

        it "freezes data and header for TSV::Row" do
          subject.each do |i|
            expect(i.data).to be_frozen
            expect(i.header).to be_frozen
          end
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

        it "freezes data and header for TSV::Row" do
          subject.each do |i|
            expect(i.data).to be_frozen
            expect(i.header).to be_frozen
          end
        end
      end
    end
  end

  describe "#with_header" do
    subject { table.with_header }

    it "returns a Table with header option set to true" do
      expect(subject.header).to be true
    end
  end

  describe "#without_header" do
    subject { table.without_header }

    it "returns a Table with header option set to false" do
      expect(subject.header).to be false
    end
  end

  describe "enumerator interfaces" do
    ( Enumerable.instance_methods(false) + Enumerator.instance_methods(false) ).each do |name|
      it "delegates #{name} to enumerator" do
        expect(table.enumerator).to receive(name)
        table.send(name)
      end
    end
  end
end
