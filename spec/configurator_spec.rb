require 'spec_helper'
require 'foundry/configurator'

describe Foundry::Configurator do
  subject { Foundry::Configurator }

  it 'must be passed either a "file_name" or "uri"' do
    expect { subject.configure }.to raise_error
  end

  it 'will attempt to load from a file' do
    expect(Foundry::Loaders::File).to receive(:load) { '' }
    subject.configure(:file_name => '')
  end

  it 'will attempt to load from a uri' do
    expect(Foundry::Loaders::Uri).to receive(:load) { '' }
    subject.configure(:uri => '')
  end

  it 'will fail-fast if the YAML is invalid' do
    expect(Foundry::Loaders::File).to receive(:load)
    expect { subject.configure(:file_name => '') }.to raise_error
  end

  it 'will fail-fast if the ERB raises an error' do
    expect(Foundry::Loaders::File).to receive(:load) { 'foo: <%= 1/0 %>' }
    expect { subject.configure(:file_name => '') }.to raise_error
  end

  it 'can parse [nested] YAML/ERB' do
    expect(Foundry::Loaders::File).to receive(:load) { <<-YAML
      root:
        erb: <%= 1 * 2 * 3 %>
        float: 123.0
        integer: 42
        list:
          - uno
          - dos
          - tres
        string: hello world
    YAML
    }
    expect(subject.configure(:file_name => '')).to eq(
      OpenHash.new(
        'root' => OpenHash.new(
          'erb' => 6,
          'float' => 123.0,
          'integer' =>  42,
          'list' => %w[uno dos tres],
          'string' => 'hello world'
        )
      )
    )
  end
end
