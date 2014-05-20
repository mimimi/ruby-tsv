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

      subject.next.should == TSV::Row.new( ['0', '1', '2'], headers )
      subject.next.should == TSV::Row.new( ['one', 'two', 'three'], headers )
      subject.next.should == TSV::Row.new( ['weird data', 's@mthin#', 'else'], headers )

      subject.next.should be_nil
    end
  end
end
