require 'spec_helper'

describe Foundry::Parsers::JSON do
  it 'can parse JSON' do
    expect(subject.parse('{ "foo": "bar" }')).to eq({ 'foo' => 'bar' })
  end

  it 'will raise an error if the JSON is unparseable' do
    expect { subject.parse(nil) }.to raise_error TypeError
  end
end
