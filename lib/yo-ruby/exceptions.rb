class Yo
  class YoApiKeyMustEqual36CharactersException < Exception; end
  class YoCannotHttpWithoutApiTokenException < Exception; end

  class YoUserNotFound < Exception; end
  class YoRateLimitExceeded < Exception; end
end