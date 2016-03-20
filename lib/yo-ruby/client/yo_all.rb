class Yo
  class Client
    class YoAll
      def initialize(link_or_location = nil)
        @parameters = {}

        unless link_or_location.nil?
          if link_or_location.to_s.start_with?('http://') || link_or_location.to_s.start_with?('https://')
            @parameters.merge!(link: link_or_location)
          elsif link_or_location.is_a?(Array)
            @parameters.merge!(location: link_or_location.join(';'))
          elsif link_or_location.is_a?(Hash)
            @parameters.merge!(location: link_or_location.values.join(';'))
          else
            @parameters.merge!(location: link_or_location)
          end
        end
      end

      def as_response
        Response.new(http_request)
      end

      private

      def http_request
        @http_request ||= HTTP.post('/yoall/', @parameters)
      end
    end
  end
end