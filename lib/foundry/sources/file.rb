module Foundry
  module Sources
    class File
      def load(root_path, relative_path, opts)
        file_path = ::File.join(root_path, relative_path)
        raise "Unknown configuration file: #{file_path}" unless ::File.exists?(file_path)
        ::File.read(file_path)
      end
    end
  end
end
