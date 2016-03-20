require 'spec_helper'

RSpec.describe Yo::Response do
  let(:response) { Yo::Response.new(example_response) }

  context "Status code" do
    it 'should return 200 by default' do
      expect(response.status_code).to eq(200)
    end

    it 'should return code if provided' do
      response = Yo::Response.new(example_response.merge("code" => 404))

      expect(response.status_code).to eq(404)
    end
  end

  context "Validations" do
    context '#id' do
      it { expect(response.id).to eq(example_response["yo_id"]) }
    end

    context '#ok?' do
      it 'should return true if success is true' do
        expect(response.ok?).to eq(true)
      end

      it 'should return false if success is false' do
        response = Yo::Response.new(example_response.merge("success" => false))

        expect(response.ok?).to eq(false)
      end
    end

    context '#error? || #error' do
      it 'should return true if errors exist' do
        response = Yo::Response.new(example_response.merge("error" => "API Key is Invalid"))

        expect(response.error?).to eq(true)
        expect(response.error).to eq("API Key is Invalid")
      end

      it 'should return false if no exists exist' do
        expect(response.error?).to eq(false)
        expect(response.error).to be_nil
      end
    end

    it 'removes recipient from output if contained within response' do
      expect(response).to be_a_kind_of(Yo::Response)
      expect(response.output).to be_a_kind_of(Hash)
      expect(response.user).to be_a_kind_of(Yo::User)
      expect(response.output["yo_id"]).not_to be_nil
      expect(response.output["recipient"]).to be_nil
    end
  end

  private

  def example_response
    {
      "yo_id"     => "1234567890",
      "success"   => true,
      "recipient" => {
        "display_name"    => "John Snow",
        "first_name"      => "John",
        "last_name"       => "Snow",
        "name"            => "John Snow",
        "is_api_user"     => false,
        "is_subscribable" => false,
        "needs_location"  => true,
        "photo"           => "http://www.google.com/images/logo.gif",
        "type"            => "user",
        "user_id"         => 100,
        "username"        => "JOHNSNOW",
        "yo_count"        => 500
      }
    }
  end
end