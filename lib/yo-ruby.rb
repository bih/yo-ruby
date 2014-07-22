require 'singleton'
require 'httparty'

class YoException < Exception
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
	def self.yo(username)
		self.__post('/yo/', { :username => username })["result"] == "OK"
	end

	def self.yo!(username)
		self.yo(username)
	end

	def self.all
		self.__post('/yoall/')["result"] == "OK"
	end

	def self.all!
		self.all
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
		yield(parameters[:username].to_s) if parameters.keys.length > 0 and parameters.include?(:username)
	end

	def self.from(params, username)
		parameters = __clean(params)
		yield if parameters.keys.length > 0 and parameters.include?(:username)
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
			if res.parsed_response.keys.include?("error") or res.parsed_response["code"] == 141
				raise YoException.new(res.parsed_response["error"])
			end

			res.parsed_response
		end

		def self.__clean(hash)
			new_hash = {}
			hash.each { |k, v| new_hash[k.to_sym] = v } if hash.is_a?(Hash)
			new_hash
		end
end