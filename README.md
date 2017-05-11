# Foundry

[![Build Status](https://secure.travis-ci.org/jzaleski/foundry.png?branch=master)](http://travis-ci.org/jzaleski/foundry)
[![Dependency Status](https://gemnasium.com/jzaleski/foundry.png)](https://gemnasium.com/jzaleski/foundry)

An application configuration gem that aims to keep it simple

Let's face it, there are a number of problems when application/environment
configuration logic is too tightly coupled with the configuration-data itself.
This gem aims to keep it simple and fully decouple the two concerns.

Features:

* Can load JSON or YAML from a local-file
* Can load JSON or YAML from a HTTP/HTTPS endpoint
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
# defaults to a source-type of `Foundry::Sources::URI` and a parser-type of `Foundry::Parsers::YAML`
config = Foundry::Configurator.configure(
  :root_path => 'http-or-https-root-url',
  :relative_path => 'relative-path-to-file',
)
```

Loading YAML from a HTTP/HTTPS endpoint using "Basic Authentication":

```ruby
config = Foundry::Configurator.configure(
  :root_path => 'http-or-https-root-url',
  :relative_path => 'relative-path-to-file',
  :username => 'basic-auth-username',
  :password => 'basic-auth-password'
)
```

Fetching top-level and nested values:

```ruby
# The examples below assume that a file containing the following has already
# been loaded and processed by a call to `Foundry::Configurator.configure` (into
# a variable named `config`).
#
# ---
# value1: value
# value2:
#   nested_value1: value

# Fetching a top-level value using dot-notation
value1 = config.value1

# Fetching a nested value using dot-notation
nested_value1 = config.value2.nested_value1

# Fetching a top-level value by key
value1 = config['value1']

# Fetching a nested value by key
nested_value1 = config['value2']['nested_value1']
```

Inheritance support:

```ruby
# The examples below assume that there are two files available, relative to the
# `root_path`, named "file1.yml" and "file2.yml" (and that "file2.yml" inherits
# from "file1.yml" -- it is immaterial at this point whether the file-format is
# JSON or YAML).
#
# When using the YAML parser, the file contents would be as follows:
#
# === file1.yml ===
#
# ---
# value1: value
#
# === file2.yml ===
#
# ---
# value2: value
# inherit: file1.yml
#
# When using the JSON parser, the file contents would be as follows:
#
# === file1.json ===
#
# { "value1": "value" }
#
# === file2.json ===
#
# { "inherit": "file1.json", "value2": "value" }
#
# It is also assumed that the files have already been loaded and processed by a
# call to `Foundry::Configurator.configure` (into a variable named `config`).
#
# Regardless of parser-type the result now contains values for both `value1` and
# `value2` and can be used as follows (it is worth noting that the `inherit` key
# is removed during the configuration process):

# Fetching `value1` and `value2` using dot-notation
value1 = config.value1
value2 = config.value2

# Fetching `value1` and `value2` by key
value1 = config['value1']
value2 = config['value2']
```

## Contributing

1. Fork it ( http://github.com/jzaleski/foundry/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
