require 'spec_helper'

RSpec.describe Yo::Configuration do
  context "Good API Key" do
    GOOD_API_KEY = "12345-12345-12345-12345-12345-123456"

    it "should set api_key by method" do
      Yo::Configuration.api_key = GOOD_API_KEY

      expect(Yo::Configuration.api_key).to be(GOOD_API_KEY)
    end

    it "should set api_key by block" do
      Yo::Configuration.setup do |config|
        config.api_key = GOOD_API_KEY
      end

      expect(Yo::Configuration.api_key).to be(GOOD_API_KEY)
    end
  end

  context "Bad API Key" do
    BAD_API_KEY = "abcdef-ghi"

    it "raises error by method" do
      expect {
        Yo::Configuration.api_key = BAD_API_KEY
      }.to raise_error(Yo::YoApiKeyMustEqual36CharactersException)
    end

    it "raises error by block" do
      expect {
        Yo::Configuration.setup do |config|
          config.api_key = BAD_API_KEY
        end
      }.to raise_error(Yo::YoApiKeyMustEqual36CharactersException)
    end
  end
end