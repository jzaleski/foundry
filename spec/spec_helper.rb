require 'rspec'
require File.expand_path('../../lib/foundry.rb', __FILE__)

RSpec.configure do |config|
  config.color_enabled = true if config.respond_to?(:color_enabled)
end
