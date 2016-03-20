class Yo
  class Configuration
    class << self
      FIELDS = [:api_key]

      def setup
        if block_given?
          yield(self)
        end
      end

      def api_key=(api_key)
        if api_key != nil && api_key.length != 36
          raise YoApiKeyMustEqual36CharactersException
        end

        @api_key = api_key
      end

      attr_reader *FIELDS
    end
  end
end