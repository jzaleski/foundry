module Foundry
  module Sources
    class URI
      def load(config_root, relative_uri, opts)
        uri = ::URI.join(config_root, relative_uri)
        client = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          client.use_ssl = true
          client.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(uri.request_uri)
        if (username = opts[:username]) && (password = opts[:password])
          request.basic_auth(username, password)
        end
        response = client.request(request)
        raise "Unknown configuration file: #{uri}" unless response.is_a?(Net::HTTPSuccess)
        response.body
      end
    end
  end
end
