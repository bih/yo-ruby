require 'singleton'
require 'httparty'

require 'yo-ruby/exceptions'
require 'yo-ruby/configuration'
require 'yo-ruby/http'
require 'yo-ruby/response'
require 'yo-ruby/types/user'

require 'yo-ruby/client/yo'
require 'yo-ruby/client/yo_all'
require 'yo-ruby/client/subscribers'

class Yo
  class << self
    def yo!(username:)
      Client::Yo.new(username).as_response
    end

    def link!(username:, link:)
      Client::Yo.new(username, link).as_response
    end

    def location!(username:, location:)
      Client::Yo.new(username, location).as_response
    end

    def all!(link_or_location = nil)
      Client::YoAll.new(link_or_location).as_response
    end

    def subscribers
      Client::Subscribers.new.count
    end
  end
end