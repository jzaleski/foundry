module Foundry
  class Configurator
    def self.configure(opts)
      Configurator.new.configure(opts)
    end

    def configure(opts)
      with_opts(opts) do
        structify(
          parse_yaml(
            evaluate_erb(
              load_yaml
            )
          )
        )
      end
    end

    private

    attr_reader :opts

    def config_root
      opts.fetch(:config_root)
    end

    def evaluate_erb(str)
      ERB.new(str).result
    end

    def file_name
      opts.fetch(:file_name)
    end

    def load_yaml
      source.load(
        config_root,
        file_name,
        opts
      )
    end

    def parse_yaml(str)
      YAML.load(str)
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

    def with_opts(opts)
      @opts = opts
      yield
    ensure
      @opts = nil
    end
  end
end
