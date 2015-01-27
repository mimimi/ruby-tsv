require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
require 'tempfile'

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
  end

  describe "intermediate file handle" do
    subject { lambda { |path| TSV::FileCyclist.new(path) } }

    it "raises IOError on write attempt" do
      # Comments in tests, groovy

      # Let's wedge ourselves into the execution chain and grab the File object
      # So that we can do whatever dirty things we want with it
      # Every call to File.new will mirror incoming arguments to our local `oh_dear` variable
      # I also know I'll call it the second time in the test, thus `twice`
      oh_dear = nil
      expect(File).to receive(:new).and_wrap_original { |m, *args| oh_dear = *args; m.call(*args) }.twice

      tempfile = Tempfile.new('tsv_test')
      TSV::FileCyclist.new(tempfile.path).data_enumerator

      handle_clone = File.new(*oh_dear)
      expect{ handle_clone.puts('test string please ignore') }.to raise_error(IOError, 'not opened for writing')
    end
  end
end
