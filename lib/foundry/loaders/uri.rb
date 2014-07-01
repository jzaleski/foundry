module Foundry
  module Loaders
    class Uri
      def self.load(uri, opts)
        Net::HTTP.get(URI.parse(uri))
      end
    end
  end
end
