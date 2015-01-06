require 'singleton'
require 'httparty'

class YoAPI; end
class YoException < Exception; end
class YoUserNotFound < YoException; end
class YoRateLimitExceeded < YoException; end

# An interface to it all.
class YoAPI
  include Singleton
  include HTTParty

  # format(:json) # Expected response for HTTParty to parse is JSON

  # Private methods.
  private
    def self.clean_hash(hash)
      new_hash = {}

      hash.each do |k, v|
        new_hash[k.to_sym] = v
      end if hash.is_a?(Hash)

      new_hash
    end
end

# The core, stable API.
class Yo < YoAPI
	base_uri "api.justyo.co"
	attr_writer :api_key

	# Authentication stuffs.
	def self.api_key
		@api_key
	end

	def self.api_key?
		not @api_key.nil?
	end

	def self.api_key=(api_key)
		raise YoException.new("Invalid Yo API Key - must be 36 characters in length") if api_key.to_s.length != 36 or not api_key.is_a?(String)
		@api_key = api_key
	end

	# Yo calls.
	def self.yo(username, extra_params = {})
		http_post('/yo/', { :username => username }.merge(extra_params))["success"] == true
	end

	def self.yo!(username, extra_params = {})
		yo(username, extra_params)
	end

	def self.all(extra_params = {})
		http_post('/yoall/', extra_params)["success"] == true
	end

	def self.all!(extra_params = {})
		all(extra_params)
	end

	def self.subscribers
		http_get('/subscribers_count/')["count"].to_i
	end

	def self.subscribers?
		subscribers > 0
	end

	# Receive a basic yo.
	def self.receive(params)
		parameters = clean_hash(params)
		yield(parameters[:username].to_s) if block_given? and parameters.include?(:username)
	end

	# Receive a yo with a link (also known as YOLINK).
	def self.receive_with_link(params)
		parameters = clean_hash(params)
		yield(parameters[:username].to_s, parameters[:link].to_s) if block_given? and parameters.include?(:username) and parameters.include?(:link)
	end

	# Receive a yo with a location (also known as @YO).
	def self.receive_with_location(params)
		parameters = clean_hash(params)
		lat, lon = parameters[:location].to_s.split(';').map{ |i| i.to_f }
		yield(parameters[:username].to_s, lat, lon) if block_given? and parameters.include?(:username) and parameters.include?(:location)
	end

  # Private methods.
  private
    def self.http_post(endpoint, params = {})
      http_parse(post(endpoint, { body: params.merge(api_token: @api_key) }))
    end

    def self.http_get(endpoint, params = {})
      http_parse(get(endpoint, { query: params.merge(api_token: @api_key) }))
    end

    def self.http_parse(res)
      begin
        if res.parsed_response.keys.include?("error") or res.parsed_response["code"] == 141
          raise YoUserNotFound.new(res.parsed_response["error"])
        end

        return res.parsed_response
      rescue NoMethodError => e
        raise YoRateLimitExceeded.new(res.parsed_response)
      rescue JSON::ParserError => e
        raise YoException.new(e)
      end
    end
end

# ------------->
# This *is* strictly in beta. We're reverse engineering Yo here. May break at any point unexpectedly.
# - Bilawal Hameed
# <-------------

class Yo::Beta < YoAPI; end;
class Yo::Beta::AuthorizationInvalid < YoException; end
class Yo::Beta::TooManyRequests < YoException; end

class Yo::Beta < YoAPI
  base_uri "newapi.justyo.co"

  # Base.
  attr_accessor :authorization_code, :rate_limits

  # Username and password.
  def self.login_with_basic(username, password)
    response = self.http_post('/rpc/login', { username: username.to_s.upcase, password: password.to_s }).parsed_response
    instance.authorization_code = (response["tok"].to_s rescue instance.authorization_code)

    login_success = response["code"] == 101 ? false : true
    yield(self) if block_given? and login_success

    login_success
  end

  # Login with code.
  def self.login_with_code(code)
    instance.authorization_code = code

    begin
      if self.me.keys.length > 0
        yield(self) if block_given?
        return true
      else
        return false
      end
    rescue YoException => e
      return false
    end
  end

  # Yo Contacts.
  def self.contacts
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    http_post('/rpc/get_contacts').parsed_response["contacts"] rescue []
  end

  # Yo someone.
  def self.yo(username, extra_params = {})
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    response = http_post('/rpc/yo', { to: username }.merge(extra_params)).parsed_response
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoUserNotFound.new(response["error"].to_s) if (response["code"].to_i rescue 0) == 404

    # Did it successfully Yo?
    response["success"] == true
  end

  def self.yo!(username)
    yo(username)
  end

  def self.yo_with_link(username, link)
    yo(username, link: link)
  end

  def self.yo_with_location(username, latitude, longitude)
    yo(username, location: [latitude, longitude].map{|k| k.to_s}.join(";"))
  end

  # Add someone.
  def self.add(username)
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    
    response = http_post('/rpc/add', { username: username })
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response == {}
  end

  def self.add!(username); add(username); end

  # Block/unblock users.
  def self.block(username)
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    http_post('/rpc/block', { username: username })
    true
  end

  def self.block!(username); block(username); end

  def self.unblock(username)
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    http_post('/rpc/unblock', { username: username })
    true
  end

  def self.unblock!(username); unblock(username); end

  # Profiles
  def self.profile(username)
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    response = http_post('/rpc/get_profile', { username: username })
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response
  end

  # My profile.
  def self.me
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    http_post('/rpc/get_me').parsed_response
  end

  # Update profile.
  def self.update_me(params = {})
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    http_post('/rpc/set_me', params).parsed_response["user"]
  end

  # My API accounts.  
  def self.my_accounts
    raise Yo::Beta::AuthorizationInvalid unless authorized?
    http_post('/rpc/list_my_api_accounts').parsed_response["accounts"] rescue []
  end

  # Add a new Yo account.
  def self.create_account(username, extra_params = {})
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    extra_params[:name] = extra_params[:name] or ""
    extra_params[:callback] = extra_params[:callback] or nil
    extra_params[:dont_send_api_email] = extra_params[:dont_send_api_email] or true
    extra_params[:needs_location] = extra_params[:needs_location] or false

    response = http_post('/rpc/new_api_account', { username: username }.merge(extra_params))
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response
  end

  # Update API account.
  def self.update_account(username, params)
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    params[:name] = params[:name] or ""
    params[:callback] = params[:callback] or nil
    params[:dont_send_api_email] = params[:dont_send_api_email] or true
    params[:needs_location] = params[:needs_location] or false

    response = http_post('/rpc/set_api_account', { username: username }.merge(params))
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    response.parsed_response["user"]
  end

  # Update Bitly token for Yo account.
  def self.set_bitly_token_for_account(username, bitly_token)
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    response = http_post('/rpc/set_bitly_token', { username: username, bitlyToken: bitly_token })
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response == {}
  end

  # Yo from an API account.
  def self.yo_from_account(from, username, extra_params = {})
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    response = http_post('/rpc/yo_from_api_account', { username: from, to: username }.merge(extra_params))
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response["success"] == true
  end

  # Get broadcasted links
  def self.get_broadcasted_links(username)
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    response = http_post('/rpc/get_broadcasted_links', { username: username })
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response
  end

  # Subscribers.
  def self.subscribers(username)
    raise Yo::Beta::AuthorizationInvalid unless authorized?

    response = http_post('/rpc/count_subscribers', { username: username })
    raise Yo::Beta::TooManyRequests.new if response.code.to_i == 429
    raise YoException.new(response.parsed_response["error"]) if response.code.to_i != 200
    response.parsed_response["count"].to_i
  end

  def self.subscribers?(username)
    subscribers(username).to_i > 0
  end

  # Rate limiting.
  def self.rate_limits
    instance.rate_limits || { limit: nil, remaining: nil, reset: nil }
  end

  def self.rate_limit_reached?
    instance.rate_limits[:remaining].to_i <= 0 and not instance.rate_limits[:remaining].nil?
  end

  # Authorization.
  def self.authorized?
    not instance.authorization_code.nil?
  end

  # Private methods.
  private
    def self.http_post(endpoint, params = {}, headers = {})
      headers.merge!({ "Authorization" => "Bearer #{instance.authorization_code}" }) if authorized?
      response = post(endpoint, { body: params, headers: headers })

      instance.rate_limits = { limit: response.headers['x-ratelimit-limit'].to_i, remaining: response.headers['x-ratelimit-remaining'].to_i, reset: Time.at(response.headers['x-ratelimit-reset'].to_i) } rescue nil
      response
    end

    def self.http_get(endpoint, params = {}, headers = {})
      headers.merge!({ "Authorization" => "Bearer #{instance.authorization_code}" }) if authorized?
      response = get(endpoint, { query: params, headers: headers })

      instance.rate_limits = { limit: response.headers['x-ratelimit-limit'].to_i, remaining: response.headers['x-ratelimit-remaining'].to_i, reset: Time.at(response.headers['x-ratelimit-reset'].to_i) } rescue nil
      response
    end
end