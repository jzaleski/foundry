class Hash
  def deep_merge(other)
    dup.deep_merge!(other)
  end

  def deep_merge!(other)
    other.each_pair do |other_key, other_value|
      this_value = self[other_key]
      if this_value.is_a?(Hash) && other_value.is_a?(Hash)
        self[other_key] = this_value.deep_merge(other_value)
      else
        self[other_key] = other_value
      end
    end
    self
  end

  def without(*keys)
    dup.without!(*keys)
  end

  def without!(*keys)
    self.reject! { |key, _| keys.include?(key) }; self
  end
end
