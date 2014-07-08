# Foundry 

[![Build Status](https://secure.travis-ci.org/jzaleski/foundry.png?branch=master)](http://travis-ci.org/jzaleski/foundry)
[![Dependency Status](https://gemnasium.com/jzaleski/foundry.png)](https://gemnasium.com/jzaleski/foundry)

An application configuration gem that aims to keep it simple

## Installation

Add this line to your application's Gemfile:

    gem 'foundry'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foundry

## Usage

Loading from a locale-file:

```ruby
Foundry::Configurator.configure(:file_name => 'path-to-local-file')
```

Loading from a HTTP/HTTPS endpoint:

```ruby
Foundry::Configurator.configure(:uri => 'http-or-https-endpoint')
```

Loading from a HTTP/HTTPS endpoint using "Basic Authentication":

```ruby
Foundry::Configurator.configure(:uri => 'http-or-https-endpoint', :username => 'basic-auth-username', :password => 'basic-auth-password')
```

## Contributing

1. Fork it ( http://github.com/jzaleski/foundry/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
