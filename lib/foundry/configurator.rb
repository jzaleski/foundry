module Foundry
  class Configurator
    class << self
      def configure(opts={})
        structify(
          load_yaml(
            evaluate_erb(
              load_by_filename_or_uri(opts)
            )
          )
        )
      end

      private

      def evaluate_erb(str)
        ERB.new(str).result
      end

      def load_by_filename_or_uri(opts)
        if file_name = opts.delete(:file_name)
          Foundry::Loaders::File.load(file_name, opts)
        elsif uri = opts.delete(:uri)
          Foundry::Loaders::Uri.load(uri, opts)
        else
          raise NotImplementedError
        end
      end

      def load_yaml(str)
        YAML.load(str)
      end

      def structify(object)
        case object
        when Array
          object.map do |value|
            structify(value)
          end
        when Hash
          Foundry::HashStruct.new.tap do |mash|
            object.each do |key, value|
              mash[key] = structify(value)
            end
          end
        else
          object
        end
      end
    end
  end
end
