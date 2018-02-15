def safe_require(name)
  require name
rescue LoadError
  false
end

require 'foundry/parsers'
require 'foundry/refinements'
require 'foundry/sources'
require 'foundry/template_engines'
require 'foundry/version'

require 'foundry/configurator'
