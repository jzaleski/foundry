module Foundry
  module Loaders
    class File
      def self.load(file_name, opts)
        ::File.read(file_name)
      end
    end
  end
end
