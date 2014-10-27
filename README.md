# Foundry 

[![Build Status](https://secure.travis-ci.org/jzaleski/foundry.png?branch=master)](http://travis-ci.org/jzaleski/foundry)
[![Dependency Status](https://gemnasium.com/jzaleski/foundry.png)](https://gemnasium.com/jzaleski/foundry)

An application configuration gem that aims to keep it simple

Let's face it, there are a number of problems when application/environment
configuration logic is too tightly coupled with the configuration-data itself.
This gem aims to keep it simple and fully decouple the two concerns.

Features:

* Can load YAML from a local-file
* Can load YAML from a HTTP/HTTPS endpoint
* Supports Basic Authentication for HTTP{,S} endpoints
* Supports ERB interpolation
* Returns an easy to navigate object-graph

## Installation

Add this line to your application's Gemfile:

    gem 'foundry'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foundry

## Usage

Loading from a local-file:

```ruby
config = Foundry::Configurator.configure(
  :root_path => 'local-root-path',
  :relative_path => 'relative-path-to-file',
  :source_type => Foundry::Sources::File
)
```

Loading from a HTTP/HTTPS endpoint:

```ruby
config = Foundry::Configurator.configure(
  :root_path => 'http-or-https-root-url',
  :relative_path => 'relative-path-to-file',
  :source_type => Foundry::Sources::URI
)
```

Loading from a HTTP/HTTPS endpoint using "Basic Authentication":

```ruby
config = Foundry::Configurator.configure(
  :root_path => 'http-or-https-root-url',
  :relative_path => 'relative-path-to-file',
  :source_type => Foundry::Sources::URI,
  :username => 'basic-auth-username',
  :password => 'basic-auth-password'
)
```

Using the "config" object (defined above):

```ruby
# The examples below assume that the following YAML was loaded by a call to
# "Foundry::Configurator.configure" and into a variable named "config"
#
# ---
# some_key:
#   some_nested_key: value

# Fetch a value using dot-notation
value = config.some_key.some_nested_key

# Fetch a value by key
value = config['some_key']['some_nested_key']
```

## Contributing

1. Fork it ( http://github.com/jzaleski/foundry/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
