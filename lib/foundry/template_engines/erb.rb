safe_require('erb')

if defined?(ERB)
  module Foundry
    module TemplateEngines
      class ERB
        def evaluate(str)
          ::ERB.new(str).result
        end
      end
    end
  end
end
