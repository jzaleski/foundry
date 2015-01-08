require 'spec_helper'

describe Foundry::Configurator do
  REQUIRED_OPTS = [
    :root_path,
    :relative_path
  ]

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

  it 'will fail-fast if the parser raises an error' do
    with_source do |source|
      with_parser do |parser|
        expect(source).to receive(:load)
        expect(parser).to receive(:parse).and_call_original
        expect { subject.configure(opts) }.to raise_error
      end
    end
  end

  it 'will fail-fast if the template-engine raises an error' do
    with_source do |source|
      expect(source).to receive(:load) { 'foo: <%= 1/0 %>' }
      expect(template_engine).to receive(:evaluate).and_call_original
      expect { subject.configure(opts) }.to raise_error
    end
  end

  it 'can load, parse and evaluate then return a valid result' do
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

  def with_defaults_merged(opts={})
    opts.merge({ :exactly => :once })
  end

  def with_parser(opts={})
    with_defaults_merged(opts) do |merged_opts|
      parser = merged_opts[:parser_type].new
      expect(subject).to receive(:parser).exactly(opts[:exactly]) { parser }
      yield parser
    end
  end

  def with_source(opts={})
    with_defaults_merged(opts) do |merged_opts|
      source = merged_opts[:source_type].new
      expect(subject).to receive(:source).exactly(opts[:exactly]) { source }
      yield source
    end
  end

  def with_template_engine(opts={})
    with_defaults_merged(opts) do |merged_opts|
      template_engine = merged_opts[:template_engine_type].new
      expect(subject).to receive(:template_engine).exactly(opts[:exactly]) { template_engine }
      yield template_engine
    end
  end
end
