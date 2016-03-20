class Yo
  class User
    API_FIELDS = [
      :display_name, :first_name, :is_api_user,
      :is_subscribable, :last_name, :name,
      :needs_location, :photo, :type,
      :user_id, :username, :yo_count
    ]

    def initialize(options = {})
      options.each do |key, value|
        self.send("%s=" % key, value)
      end
    end

    def method_missing(method_sym, *args, &block)
      field = method_sym[0...-1]

      if API_FIELDS.include?(field.to_sym)
        return (self.send(field) != false && self.send(field) != nil) || self.send(field) == true
      end
    end

    attr_accessor *API_FIELDS
  end
end