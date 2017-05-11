require 'erb'


module Foundry
  module TemplateEngines
    class ERB
      def evaluate(str)
        ::ERB.new(str).result
      end
    end
  end
end
