require 'spec_helper'

describe Foundry::Parsers::XML do
  it 'can parse XML' do
    expect(subject.parse('<config><foo>bar</foo></config>')).to \
      eq({ 'foo' => 'bar' })
  end

  it 'will raise an error if the XML is not in the correct format' do
    expect { subject.parse('<foo>bar</foo>') }.to raise_error ArgumentError
  end

  it 'will raise an error if the XML is unparseable' do
    expect { subject.parse(nil) }.to raise_error TypeError
  end
end
