module Foundry
  class Configurator
    def self.configure(opts)
      Configurator.new.configure(opts)
    end

    def configure(opts)
      with_opts(opts) do
        transmorgs = transmorgify(opts.fetch(:relative_path))
        merged = mergify(transmorgs)
        structify(merged)
      end
    end

    private

    attr_reader :opts

    def erbify(str)
      ERB.new(str).result
    end

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

    def parsify(str)
      YAML.load(str) || {}
    end

    def root_path
      opts.fetch(:root_path)
    end

    def source
      source_type.new
    end

    def source_type
      opts.fetch(:source_type)
    end

    def structify(object)
      case object
      when Array
        object.map do |value|
          structify(value)
        end
      when Hash
        OpenStruct.new.tap do |open_struct|
          object.each do |key, value|
            open_struct.send("#{key}=", structify(value))
          end
        end
      else
        object
      end
    end

    def transmorgify(relative_path)
      parsed = parsify(erbify(loadify(relative_path)))
      inherit = parsed.delete('inherit')
      Array(inherit && transmorgify(inherit)) << parsed
    end

    def with_opts(opts)
      @opts = opts
      yield
    ensure
      @opts = nil
    end
  end
end
