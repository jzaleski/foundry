require 'spec_helper'

describe Foundry::Configurator do
  REQUIRED_OPTS = [
    :root_path,
    :relative_path,
    :source_type,
  ]

  subject { Foundry::Configurator.new }
  let(:opts) { REQUIRED_OPTS.reduce({}) { |memo, opt| memo[opt] = nil; memo } }

  REQUIRED_OPTS.each do |key|
    it %{must be passed a "#{key}"} do
      expect { subject.configure(opts.without(key)) }.to raise_error
    end
  end

  it 'will load from a source' do
    with_source do |source|
      expect(source).to receive(:load) { '' }
      expect { subject.configure(opts) }.not_to raise_error
    end
  end

  it 'will fail-fast if the YAML is invalid' do
    with_source do |source|
      expect(source).to receive(:load)
      expect { subject.configure(opts) }.to raise_error
    end
  end

  it 'will fail-fast if the ERB raises an error' do
    with_source do |source|
      expect(source).to receive(:load) { 'foo: <%= 1/0 %>' }
      expect { subject.configure(opts) }.to raise_error
    end
  end

  it 'can parse YAML/ERB' do
    with_source do |source|
      expect(source).to receive(:load) { <<-YAML
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
          'erb' => 6,
          'float' => 123.0,
          'integer' =>  42,
          'list' => %w[uno dos tres],
          'string' => 'hello world'
        )
      )
    end
  end

  it 'supports inheritance' do
    with_source(:exactly => :twice) do |source|
      expect(source).to receive(:load).and_return(
        "foo: foo\ninherit: bar",
        "bar: bar"
      )
      expect(subject.configure(opts)).to eq(
        OpenStruct.new(
          'foo' => 'foo',
          'bar' => 'bar'
        )
      )
    end
  end

  private

  def default_opts
    {
      :exactly => :once,
      :type => Foundry::Sources::File,
    }
  end

  def with_source(opts={})
    merged_opts = default_opts.merge(opts)
    source = merged_opts[:type].new
    expect(subject).to receive(:source).exactly(merged_opts[:exactly]) { source }
    yield source
  end
end
