require 'erb'
require 'net/http'
require 'ostruct'
require 'uri'
require 'yaml'

require 'foundry/loaders/file'
require 'foundry/loaders/uri'
require 'foundry/version'

module Foundry
  def self.configure(opts={})
    ostructify(
      yamlify(
        erbify(
          if file_name = opts.delete(:file_name)
            Foundry::Loaders::File.load(file_name, opts)
          elsif uri = opts.delete(:uri)
            Foundry::Loaders::Uri.load(uri, opts)
          end
        )
      )
    )
  end

  private

  def self.erbify(str)
    ERB.new(str).result
  end

  def self.ostructify(object)
    case object
    when Array
      object.map do |value|
        ostructify(value)
      end
    when Hash
      OpenStruct.new.tap do |memo|
        object.each do |key, value|
          memo[key] = ostructify(value)
        end
      end
    else
      object
    end
  end

  def self.yamlify(str)
    YAML.load(str)
  end
end
