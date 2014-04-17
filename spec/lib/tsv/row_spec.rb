require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe TSV::Row do
  describe "::new" do
    it "sets header and data from params" do
      t = TSV::Row.new(['data'], ['header'])

      expect(t.header).to eq(['header'])
      expect(t.data).to eq(['data'])
    end

    context "when header and data length do not match" do
      it "raises TSV::Row::InputError" do
        expect { TSV::Row.new(['data'], ['header', 'footer']) }.to raise_error(TSV::Row::InputError)
        expect { TSV::Row.new(['data', 'not data'], ['header']) }.to raise_error(TSV::Row::InputError)
      end
    end
  end

  let(:header)  { ['first', 'second', 'third'] }
  let(:data)    { ['one',   'two',    'three'] }

  subject(:row) { TSV::Row.new(data, header) }

  describe "#[]" do
    describe "array interface compatibility" do
      context "when provided with element number" do
        it "returns requested element" do
          expect(subject[1]).to eq "two"
        end
      end

      context "when provided with negative offset" do
        it "returns requested element" do
          expect(subject[-1]).to eq "three"
        end
      end

      context "when provided with header name" do
        it "returns requested element" do
          expect(subject['third']).to eq "three"
        end
      end

      context "when provided with nil or symbol" do
        it "raises TSV::Row::InvalidKey" do
          expect { subject[nil] }.to raise_error(TSV::Row::InvalidKey)
          expect { subject[:something] }.to raise_error(TSV::Row::InvalidKey)
        end
      end

      context "when provided with unknown numeric key" do
        let(:cases) { [-(data.length + 1), data.length, 500, -500]}

        it "raises TSV::Row::UnknownKey" do
          cases.each do |item|
            expect { subject[item] }.to raise_error(TSV::Row::UnknownKey)
          end
        end
      end

      context "when provided with unknown string key" do
        it "raises TSV::Row::UnknownKey" do
          expect { subject['something'] }.to raise_error(TSV::Row::UnknownKey)
        end
      end
    end
  end

  describe "#[]=" do
    it "raises TSV::ReadOnly exception" do
      expect { subject['a'] = 123 }.to raise_error(TSV::ReadOnly, 'TSV data is read only. Export data to modify it.')
    end
  end

  describe "accessors" do
    describe "header" do
      it "does not have setter" do 
        expect(subject).to_not respond_to(:"header=")
      end

      it "has getter" do
        expect(subject.header).to eq ['first', 'second', 'third']
      end
    end

    describe "data" do
      it "does not have setter" do 
        expect(subject).to_not respond_to(:"header=")
      end

      it "has getter" do
        expect(subject.data).to eq ['one',   'two',    'three']
      end
    end
  end

  describe "iterators" do
    describe "Enumerable #methods (except #to_h, which we have a better implementation for)" do
      (Enumerable.instance_methods(false) - [:to_h]).each do |name|
        it "delegates #{name} to data array" do
          expect(subject.data).to receive(name)
          subject.send(name)
        end
      end
    end

    describe "#with_header" do
      subject { row.with_header }

      it "gathers header and data into hash" do
        expect(subject).to eq({
          "first"  => "one",
          "second" => "two",
          "third"  => "three"
        })
      end
    end

    describe "#to_h" do
      subject { row.to_h }

      it "gathers header and data into hash" do
        expect(subject).to eq({
          "first"  => "one",
          "second" => "two",
          "third"  => "three"
        })
      end
    end
  end

  describe "#==" do
    let(:other_header) { header }
    let(:other_data)   { data }

    let(:other_row) { TSV::Row.new(other_data, other_header) }
    subject { row == other_row }

    context "when compared to TSV::Row" do
      context "when both objects' data and header are equal" do
        it { should be true }
      end

      context "when data attributes are not equal" do
        let(:other_data) { data.reverse }
        it { should be false }
      end

      context "when header attributes are not equal" do
        let(:other_header) { header.reverse }
        it { should be false }
      end

      context "when both objects' data and header are not equal" do
        let(:other_data) { data.reverse }
        let(:other_header) { header.reverse }
        it { should be false }
      end
    end

    context "when compared to something else than TSV::Row" do
      let(:other_row) { data }

      it { should be false }
    end
  end
end
