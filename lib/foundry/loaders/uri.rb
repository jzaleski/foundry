module Foundry
  module Loaders
    class Uri
      def self.load(uri, opts)
        parsed_uri = URI.parse(uri)
        http = Net::HTTP.new(parsed_uri.host, parsed_uri.port)
        if parsed_uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(parsed_uri.request_uri)
        if username = opts.delete(:username) && password = opts.delete(:password)
          request.basic_auth(username, password)
        end
        http.request(request).body
      end
    end
  end
end
