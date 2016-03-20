class Yo
  class Client
    class Subscribers
      def count
        http_request["count"]
      end

      private

      def http_request
        @http_request ||= HTTP.get('/subscribers_count/')
      end
    end
  end
end