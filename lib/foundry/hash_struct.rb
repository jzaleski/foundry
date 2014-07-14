module Foundry
  class HashStruct < OpenStruct
    def [](key)
      public_send(key.to_sym)
    end
    def []=(key, value)
      public_send("#{key.to_sym}=", value)
    end
  end
end
