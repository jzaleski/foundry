require 'spec_helper'

describe Foundry::Sources::File do
  subject { Foundry::Sources::File.new }

  it 'can load a file' do
    expect(File).to receive(:read)
    subject.load('', '', {})
  end

  it 'will raise an error if the file does not exist' do
    expect { subject.load('', '', {}) }.to raise_error
  end
end
