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

```
require 'yo-ruby'

Yo.api_key = "your-api-key"
```

**Method:** Send a yo to someone

```
begin
	Yo.yo!("username")
rescue YoException => e
	# User does not exist.
end
```

**Method:** Subscriber count

```
Yo.subscribers
```

**Method:** Send a yo to all your subscribers

```
Yo.all!
```

**Method:** Receive a yo. *You need to configure your callback URL for this.*

```
Yo.receive(params) do |username|
	puts "#{username} sent me a yo!"
end
```

**Method:** Receive a yo from a particular person. *You need to configure your callback URL for this.*

```
Yo.from(param, "username") do
	puts "I'll do something awesome because this user yo'd me!"
end
```

### Lazy Documentation
```
require 'sinatra'
require 'yo-ruby'

Yo.api_key = "your-api-key"

get '/yo/:username' do
	begin
		Yo.yo!(params[:username])
	rescue YoException => e
		puts "User doesn't exist. Wut?"
	end
end

get '/yoall' do
	Yo.all!
end

get '/subscribers' do
	puts "Subscribers: #{Yo.subscribers}"
end

get '/callback' do
	Yo.receive(params) do |username|
		# When I receive a yo to this callback, I can do something here.
	end
end
```

### Who made this?
I did. I being [Bilawal Hameed](http://github.com/bih). Released freely under the [MIT License](http://bih.mit-license.org/).