require 'spec_helper'

describe Foundry::Configurator do
  REQUIRED_OPTS = [
    :config_root,
    :file_name,
    :source_type,
  ]

  subject { Foundry::Configurator.new }
  let(:opts) { REQUIRED_OPTS.reduce({}) { |m, o| m[o] = nil; m } }

  REQUIRED_OPTS.each do |key|
    it %{must be passed a "#{key}"} do
      expect { subject.configure(opts.without(key)) }.to raise_error
    end
  end

  it 'will attempt to load from a file' do
    with_file_source do |source|
      expect(source).to receive(:load) { '' }
      expect { subject.configure(opts) }.not_to raise_error
    end
  end

  it 'will attempt to load from a uri' do
    with_uri_source do |source|
      expect(source).to receive(:load) { '' }
      expect { subject.configure(opts) }.not_to raise_error
    end
  end

  it 'will fail-fast if the YAML is invalid' do
    with_file_source do |source|
      expect(source).to receive(:load)
      expect { subject.configure(opts) }.to raise_error
    end
  end

  it 'will fail-fast if the ERB raises an error' do
    with_all_sources do |source|
      expect(source).to receive(:load) { 'foo: <%= 1/0 %>' }
      expect { subject.configure(opts) }.to raise_error
    end
  end

  it 'can parse [nested] YAML/ERB' do
    with_all_sources do |source|
      expect(source).to receive(:load) { <<-YAML
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
      expect(subject.configure(opts)).to eq(
        OpenStruct.new(
          'root' => OpenStruct.new(
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

  private

  def with_all_sources
    AVAILABLE_SOURCE_TYPES.each do |source_type|
      source = source_type.new
      expect(subject).to receive(:source) { source }
      yield source
    end
  end

  def with_file_source
    source = Foundry::Sources::File.new
    expect(subject).to receive(:source) { source }
    yield source
  end

  def with_uri_source
    source = Foundry::Sources::URI.new
    expect(subject).to receive(:source) { source }
    yield source
  end
end
