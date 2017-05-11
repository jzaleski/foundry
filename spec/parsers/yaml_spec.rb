require 'spec_helper'

describe Foundry::Parsers::YAML do
  it 'can parse YAML' do
    expect(subject.parse('foo: bar')).to eq({ 'foo' => 'bar' })
  end

  it 'will raise an error if the YAML is unparseable' do
    expect { subject.parse(nil) }.to raise_error TypeError
  end
end
