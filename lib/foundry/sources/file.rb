module Foundry
  module Sources
    class File
      def load(config_root, file_name, opts)
        file_path = ::File.join(config_root, file_name)
        raise "Unknown configuration file: #{file_name}" unless ::File.exists?(file_path)
        ::File.read(file_path)
      end
    end
  end
end
