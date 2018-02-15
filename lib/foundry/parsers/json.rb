safe_require('json')

if defined?(JSON)
  module Foundry
    module Parsers
      class JSON
        def parse(str)
          ::JSON.parse(str)
        end
      end
    end
  end
end
