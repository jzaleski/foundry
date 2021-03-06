require 'ostruct'


module Foundry
  class Configurator
    def self.configure(opts)
      new.configure(opts)
    end

    def configure(opts)
      with_opts(opts) do
        relative_path = opts.fetch(:relative_path)
        transmorg = transmorgify(relative_path)
        merged = mergify(transmorg)
        structify(merged)
      end
    end

    private

    DEFAULT_OPTS = {
      :parser_type => Foundry::Parsers::YAML,
      :source_type => Foundry::Sources::URI,
      :template_engine_type => Foundry::TemplateEngines::ERB,
    }

    attr_reader :opts

    def loadify(relative_path)
      source.load(
        root_path,
        relative_path,
        opts
      )
    end

    def mergify(transmorgs)
      transmorgs.reduce({}) { |memo, transmorg| memo.deep_merge(transmorg) }
    end

    def opts_value_or_default(key)
      opts.fetch(key, DEFAULT_OPTS.fetch(key))
    end

    def parser
      parser_type.new
    end

    def parser_type
      opts_value_or_default(:parser_type)
    end

    def parsify(str)
      parser.parse(str) || {}
    end

    def root_path
      opts.fetch(:root_path)
    end

    def source
      source_type.new
    end

    def source_type
      opts_value_or_default(:source_type)
    end

    def structify(value)
      case value
      when Array
        value.map { |item| structify(item) }
      when Hash
        OpenStruct.new.tap do |struct|
          value.each { |item| struct.send("#{item[0]}=", structify(item[1])) }
        end
      else
        value
      end
    end

    def template_engine
      template_engine_type.new
    end

    def template_engine_type
      opts_value_or_default(:template_engine_type)
    end

    def templatify(str)
      template_engine.evaluate(str)
    end

    def transmorgify(relative_path)
      parsed = parsify(templatify(loadify(relative_path)))
      next_relative_path = parsed.delete('inherit')
      Array(next_relative_path && transmorgify(next_relative_path)) << parsed
    end

    def with_opts(opts)
      @opts = opts
      yield
    ensure
      @opts = nil
    end
  end
end
