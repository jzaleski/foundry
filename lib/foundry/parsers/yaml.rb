require 'yaml'


module Foundry
  module Parsers
    class YAML
      def parse(str)
        ::YAML.load(str)
      end
    end
  end
end
