![Yo for Ruby](http://i.imgur.com/N0L8m9P.png)

# Yo! API for Ruby (v1.0.0)

[![Build Status](https://travis-ci.org/bih/yo-ruby.svg?branch=master)](https://travis-ci.org/bih/yo-ruby)

This is a Ruby API wrapper [that's fully tested](https://travis-ci.org/bih/yo-ruby). It works on Ruby 2.1 and above. This was originally written for the [Yo! hackathon in New York](http://www.eventbrite.com/e/yo-hackathon-nyc-2-letters-2-hours-ready-set-yo-tickets-12145608843?aff=eorg) (which I later won first place with [YoAuth](http://yoauth.herokuapp.com)).


### Installation

Do it through your terminal, yo.

```
$ gem install yo-ruby
```

No? Stick it in your Gemfile, yo.

```
gem 'yo-ruby', '~> 1.0.x'
```

### Documentation

Before using the Yo! API, you need to obtain a free [API key](http://dev.justyo.co/). It takes a few seconds.

**Required:** Now you need to include the library and set your API key.

```ruby
require 'yo-ruby'

Yo::Configuration.setup do |config|
  config.api_key = "[insert api key here]"
end

# Alternatively: Yo::Configuration.api_key = "[insert api key here]"
```

**Method:** Send a yo to someone

```ruby
yo = Yo.yo!("username")
yo.ok? # => true
```

**Method:** Send a yo to someone with a URL

```ruby
yo = Yo.link!("username", "http://github.com/bih/yo-ruby")
yo.ok? # => true
```

**Method:** Subscriber count

```ruby
Yo.subscribers
```

**Method:** Send a yo to all your subscribers

```ruby
Yo.all!
```


**Method:** Send a yo to all your subscribers with a URL (New)

```ruby
Yo.all!("http://github.com/bih/yo-ruby")
```

### Lazy Documentation
```ruby
require 'sinatra'
require 'yo-ruby'

Yo::Configuration.setup do |config|
  config.api_key = "[insert api key here]"
end

get '/yo/:username' do
  yo = Yo.yo!(params[:username])
  yo.ok?
end

get '/yoall' do
  yo = Yo.all!
  yo.ok?
end

get '/subscribers' do
  puts "Subscribers: #{Yo.subscribers}"
end
```

### Testing

This gem is fully tested and you can find all the tests in the `spec/yo-ruby/` folder.
You can also execute them by running the `rake` command.

```
$ rake
```

### Who made this?
[Bilawal Hameed](http://github.com/bih). Released freely under the [MIT License](http://bih.mit-license.org/).
