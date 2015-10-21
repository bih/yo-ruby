require 'singleton'
require 'httparty'

class YoException < Exception; end
class YoUserNotFound < YoException; end
class YoRateLimitExceeded < YoException; end

class Yo
	include Singleton
	include HTTParty

	base_uri "api.justyo.co"
	format   :json

	attr_writer :api_key

	# Authentication.

	def Yo.api_key?
		@api_key != nil
	end

	def Yo.api_key=(api_key)
		if api_key.to_s.length != 36 || not api_key.is_a?(String)
			raise YoException.new("Invalid Yo API key - must be 36 characters in length")
		end

		@api_key = api_key
	end

	# Yo calls.

	def Yo.yo(username, extra_params = {})
		Yo.http_post('/yo/', { username: username }.merge(extra_params))["result"] == "OK"
	end

	def Yo.yo!(username, extra_params = {})
		Yo.yo(username, extra_params)
	end

	def Yo.all(extra_params = {})
		Yo.http_post('/yoall/', extra_params)["result"] == "OK"
	end

	def Yo.all!(extra_params = {})
		Yo.all(extra_params)
	end

	def Yo.subscribers
		Yo.http_get('/subscribers_count/')["result"].to_i
	end

	def Yo.subscribers?
		Yo.subscribers > 0
	end

	# Receive a basic yo.

	def Yo.receive(params)
		parameters = clean_params

		if block_given? && parameters.include?(:username)
			yield(parameters[:username].to_s)
		end
	end

	def Yo.from(params, username)
		parameters = clean_params
	
		if block_given? && parameters.include?(:username) && parameters[:username].to_s.upcase == username.upcase
			yield
		end
	end

	# Receive a yo with a link (also known as YOLINK).

	def Yo.receive_with_link(params)
		parameters = clean_params

		if block_given? && parameters.include?(:username) && parameters.include?(:link)
			yield(parameters[:username].to_s, parameters[:link].to_s)
		end
	end

	def Yo.from_with_link(params, username)
		parameters = clean_params

		if block_given? && parameters.include?(:username) && parameters.include?(:link) && parameters[:username].to_s.upcase == username.upcase
			yield(parameters[:link].to_s)
		end
	end

	# Receive a yo with a location (also known as @YO).
	
	def Yo.receive_with_location(params)
		parameters = clean_params
		lat, lon   = parameters[:location].to_s.split(';').map(&:to_f)

		if block_given? && parameters.include?(:username) && parameters.include?(:location)
			yield(parameters[:username].to_s, lat, lon)
		end
	end

	def Yo.from_with_location(params, username)
		parameters = clean_params
		lat, lon   = parameters[:location].to_s.split(';').map(&:to_f)
		
		if block_given? && parameters.include?(:username) && parameters.include?(:location) && parameters[:username].to_s.upcase == username.upcase
			yield(parameters[:link].to_s, lat, lon)
		end
	end

	# Private methods.
	private

	def Yo.http_post(endpoint, params = {})
		query = post(endpoint, { body: params.merge(api_token: @api_key) })
		query = parse_response(query)
		query
	end

	def Yo.http_get(endpoint, params = {})
		query = get(endpoint, { query: params.merge(api_token: @api_key) })
		query = parse_response(query)
		query
	end

	def Yo.parse_response(res)
		begin
			if res.parsed_response.keys.include?("error") || res.parsed_response["code"] == 141
				raise YoUserNotFound.new("You cannot Yo yourself and/or your developer Yo usernames. Why? Ask Or Arbel, CEO of Yo - or@justyo.co") if res.parsed_response["error"][0..8] == "TypeError"
				raise YoUserNotFound.new(res.parsed_response["error"])
			end

			return res.parsed_response
		rescue NoMethodError => e
			raise YoRateLimitExceeded.new(res.parsed_response)
		rescue JSON::ParserError => e
			raise YoException.new(e)
		end
	end

	def Yo.clean_params
		new_params = params

		param.each do |key, value|
			new_params[key.to_sym] = value
		end

		new_params
	end
end