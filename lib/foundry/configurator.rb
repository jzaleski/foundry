module Foundry
  class Configurator
    class << self
      def configure(opts={})
        mashify(
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

      def mashify(object)
        case object
        when Array
          object.map do |value|
            mashify(value)
          end
        when Hash
          Hashie::Mash.new.tap do |mash|
            object.each do |key, value|
              mash[key] = mashify(value)
            end
          end
        else
          object
        end
      end
    end
  end
end
