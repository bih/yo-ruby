require 'spec_helper'

RSpec.describe Yo::HTTP do
  context "Validations" do
    it 'raises error if no api key set' do
      expect {
        Yo::Configuration.api_key = nil
        Yo::HTTP.post("http://localhost/")
      }.to raise_error(Yo::YoCannotHttpWithoutApiTokenException)
    end
  end
end