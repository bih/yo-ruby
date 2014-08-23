require 'singleton'
require 'httparty'

class YoException < Exception
end

class YoUserNotFound < YoException
end

class YoRateLimitExceeded < YoException
end

class Yo
	include Singleton
	include HTTParty

	base_uri "api.justyo.co"
	format :json

	attr_writer :api_key

	# Authentication stuffs.
	def self.api_key
		@api_key
	end

	def self.api_key?
		not @api_key.nil?
	end

	def self.api_key=(api_key)
		if api_key.to_s.length != 36 or not api_key.is_a?(String)
			raise YoException.new("Invalid Yo API key - must be 36 characters in length")
		end

		@api_key = api_key
	end

	# Yo calls.
	def self.yo(username, extra_params = {})
		self.__post('/yo/', { :username => username }.merge(extra_params))["result"] == "OK"
	end

	def self.yo!(username, extra_params = {})
		self.yo(username, extra_params)
	end

	def self.all(extra_params = {})
		self.__post('/yoall/', extra_params)["result"] == "OK"
	end

	def self.all!(extra_params = {})
		self.all(extra_params)
	end

	def self.subscribers
		self.__get('/subscribers_count/')["result"].to_i
	end

	def self.subscribers?
		self.subscribers > 0
	end

	# Receive a yo.
	def self.receive(params)
		parameters = __clean(params)
		link = parameters.keys.include?(:link) ? parameters[:link] : nil
		yield(parameters[:username].to_s, link) if parameters.keys.length > 0 and parameters.include?(:username)
	end

	def self.from(params, username)
		parameters = __clean(params)
		link = parameters.keys.include?(:link) ? parameters[:link] : nil
		yield(link) if parameters.keys.length > 0 and parameters.include?(:username) and params[:username].to_s.upcase == username.upcase
	end

	# Private methods.
	private
		def self.__post(endpoint, params = {})
			__parse(post(endpoint, { body: params.merge(api_token: @api_key) }))
		end

		def self.__get(endpoint, params = {})
			__parse(get(endpoint, { query: params.merge(api_token: @api_key) }))
		end

		def self.__parse(res)
			begin
				if res.parsed_response.keys.include?("error") or res.parsed_response["code"] == 141
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

		def self.__clean(hash)
			new_hash = {}
			hash.each { |k, v| new_hash[k.to_sym] = v } if hash.is_a?(Hash)
			new_hash
		end
end