module Releaseko
  # Custom Error object for Releaseko
  class CustomError
    attr_reader :message, :code

    def initialize(message, code = 1)
      @message = message
      @code = code
    end

    def complain
      puts "Error occurred!\n#{message}\nExit code #{code}"
      exit(code)
    end
  end
end
