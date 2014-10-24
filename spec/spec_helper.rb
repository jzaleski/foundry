require 'rspec'
require 'webmock/rspec'
require File.expand_path('../../lib/foundry.rb', __FILE__)

class Hash
  def without(*keys)
    dup.without!(*keys)
  end

  def without!(*keys)
    self.reject! { |key, _| keys.include?(key) }
  end
end

SOURCES_MODULE = Foundry::Sources
AVAILABLE_SOURCE_TYPES = SOURCES_MODULE.constants.map { |c| SOURCES_MODULE::const_get(c) }
