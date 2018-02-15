safe_require('rexml/document')

if defined?(REXML::Document)
  module Foundry
    module Parsers
      class XML
        def parse(str)
          raise TypeError if str.nil?
          root_node = REXML::Document.new(str).first
          raise ArgumentError unless root_node.name == 'config'
          result = {}
          root_node.children.each { |node| result[node.name] = node.text }
          inherit = root_node.attributes['inherit']
          raise KeyError unless result['inherit'].nil? || inherit.nil?
          result['inherit'] = inherit unless inherit.nil?
          result
        end
      end
    end
  end
end
