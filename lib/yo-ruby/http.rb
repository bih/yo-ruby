class Yo
  class HTTP
    include HTTParty

    base_uri "api.justyo.co"

    class << self
      def post(endpoint, params = {})
        super(endpoint, body: merge_with_api_token(params))
      end

      def get(endpoint, params = {})
        super(endpoint, query: merge_with_api_token(params))
      end

      private

      def merge_with_api_token(params)
        unless Yo::Configuration.api_key.nil?
          params.merge(api_token: Yo::Configuration.api_key)
        else
          raise YoCannotHttpWithoutApiTokenException
        end
      end
    end
  end
end