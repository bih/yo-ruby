class Yo
  class Response
    def initialize(output)
      if output["recipient"]
        @user = User.new(output["recipient"])
        output.delete("recipient")
      end

      @output = output
    end

    def id
      @output["yo_id"]
    end

    def ok?
      @output["success"] == true
    end

    def status_code
      @output["code"] || 200
    end

    def error
      @output["error"]
    end

    def error?
      !error.nil?
    end

    attr_reader :output, :user
  end
end