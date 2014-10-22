![Yo for Ruby](http://i.imgur.com/N0L8m9P.png)


# Unofficial Yo! API for Ruby

In preparation for the [Yo! hackathon in New York](http://www.eventbrite.com/e/yo-hackathon-nyc-2-letters-2-hours-ready-set-yo-tickets-12145608843?aff=eorg), I have written a beautifully simple Ruby wrapper that makes it incredibly easy to interact with the famous [Yo! application](http://www.justyo.co).


### Installation

Do it through your terminal, yo.

```
$ gem install yo-ruby
```

No? Stick it in your Gemfile, yo.

```
gem 'yo-ruby'
```

### Documentation

Before using the Yo! API, you need to obtain a free [API key](http://dev.justyo.co/). It takes a few seconds.

**Required:** Now you need to include the library and set your API key.

```ruby
require 'yo-ruby'

Yo.api_key = "your-api-key"
```

**Method:** Send a yo to someone

```ruby
begin
	Yo.yo!("username")
rescue YoUserNotFound => e
  # User does not exist.
rescue YoRateLimitExceeded => e
	# Rate limit of one Yo per user per minute.
end
```

**Method:** Send a yo to someone with a URL (New)

```ruby
begin
	Yo.yo!("username", link: "http://github.com/bih/yo-ruby")
rescue YoUserNotFound => e
  # User does not exist.
rescue YoRateLimitExceeded => e
	# Rate limit of one Yo per user per minute.
end
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
Yo.all!(link: "http://github.com/bih/yo-ruby")
```

**Method:** Receive a yo. *You need to configure your callback URL for this.*

```ruby
Yo.receive(params) do |username|
	puts "#{username} sent me a yo!"
end
```

**Method:** Receive a yo with a link. *You need to configure your callback URL for this.*

```ruby
Yo.receive_with_link(params) do |username, link|
	puts "#{username} sent me a yo!"
	puts "with a link to #{link}"
end
```

**Method:** Receive a yo with a location. *You need to configure your callback URL for this.*

```ruby
Yo.receive_with_location(params) do |username, latitude, longitude|
	puts "#{username} sent me a yo!"
	puts "and location is lat: #{latitude}, lon: #{longitude}"
end
```

**Method:** Receive a yo from a particular person. *You need to configure your callback URL for this.*

```ruby
Yo.from(params, "username") do
	puts "I'll do something awesome because this user yo'd me!"
end
```

**Method:** Receive a yo with a link from a particular person. *You need to configure your callback URL for this.*

```ruby
Yo.from_with_link(params, "username") do |link|
	puts "I have a HTTP link: #{link}. Do something with it?"
end
```

**Method:** Receive a yo with location from a particular person. *You need to configure your callback URL for this.*

```ruby
Yo.from_with_location(params, "username") do |latitude, longitude|
	puts "I have your location, sir! lat: #{latitude} and lon: #{longitude}"
end
```

### Lazy Documentation
```ruby
require 'sinatra'
require 'yo-ruby'

Yo.api_key = "your-api-key"

get '/yo/:username' do
	begin
		Yo.yo!(params[:username])
	rescue YoUserNotFound => e
	  puts "User does not exist."
	rescue YoRateLimitExceeded => e
		puts "Rate limit of one Yo per user per minute."
	end
end

get '/yoall' do
	Yo.all!
end

get '/subscribers' do
	puts "Subscribers: #{Yo.subscribers}"
end

get '/callback' do
	Yo.receive(params) do |username, link|
		# When I receive a yo to this callback, I can do something here.
	end
end
```

### Who made this?
[Bilawal Hameed](http://github.com/bih). Released freely under the [MIT License](http://bih.mit-license.org/).
