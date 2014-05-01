require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe TSV::Row do
  describe "::new" do
    it "sets header and data from params" do
      t = TSV::Row.new(['data'], ['header'])

      expect(t.header).to eq(['header'])
      expect(t.data).to eq(['data'])
    end

    context "when no header is provided" do
      it "generates default header in format of 0..data.length stringified" do
        t = TSV::Row.new(['data', 'data'])

        expect(t.header).to eq(['0', '1'])
        expect(t.data).to eq(['data', 'data'])
      end
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

      context "when provided with unknown string key" do
        let(:cases) { [-(data.length + 1), data.length, 500, -500]}

        it "raises TSV::Row::UnknownKey" do
          cases.each do |item|
            expect { subject[item] }.to raise_error(TSV::Row::UnknownKey)
          end
        end
      end

      context "when provided with unknown numeric key" do
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
      let(:test_data) { ['a', 'b', 'c'] }

      it "sets and gets value" do
        subject.header = test_data
        expect(subject.header).to eq test_data
      end
    end

    describe "data" do
      let(:test_data) { [['a', 'b', 'c'], ['qwe', 'dsa', 'tre']] }

      it "sets and gets value" do
        subject.header = test_data
        expect(subject.header).to eq test_data
      end
    end
  end

  describe "iterators" do
    context "Enumerable #methods" do
      Enumerable.instance_methods.each do |name|
        it "delegates #{name} to data array" do
          expect(subject.data).to receive(name)
          subject.send(name)
        end
      end
    end

    context "#with_header" do
      it "gathers header and data into hash" do
        expect(subject.with_header).to eq({
          "first"  => "one",
          "second" => "two",
          "third"  => "three"
        })
      end
    end
  end
end
