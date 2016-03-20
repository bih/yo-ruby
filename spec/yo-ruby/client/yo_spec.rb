require 'spec_helper'

RSpec.describe Yo::Client::Yo do
  context "Validations" do
    context "Initializations" do
      it 'should not raise error with one parameter' do
        expect { Yo::Client::Yo.new("JOHNSNOW") }.not_to raise_error
      end

      it 'should not raise error with two parameters' do
        expect { Yo::Client::Yo.new("JOHNSNOW", "http://google.com") }.not_to raise_error
        expect { Yo::Client::Yo.new("JOHNSNOW", [0, 0]) }.not_to raise_error
        expect { Yo::Client::Yo.new("JOHNSNOW", { lat: 0, lng: 0 }) }.not_to raise_error
        expect { Yo::Client::Yo.new("JOHNSNOW", { latitude: 0, longitude: 0 }) }.not_to raise_error
        expect { Yo::Client::Yo.new("JOHNSNOW", "0;0") }.not_to raise_error
      end
    end

    context "Methods" do
      subject { Yo::Client::Yo.new("JOHNSNOW") }

      it { expect(subject).to respond_to(:as_response) }
      it { expect(subject).not_to respond_to(:http_request) }
    end

    context "Links" do
      it 'should correctly identify a http link' do
        instance = Yo::Client::Yo.new("JOHNSNOW", "http://www.google.com")
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq({
          username: "JOHNSNOW",
          link: "http://www.google.com"
        })
      end

      it 'should correctly identify a https link' do
        instance = Yo::Client::Yo.new("JOHNSNOW", "https://www.google.com")
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq({
          username: "JOHNSNOW",
          link: "https://www.google.com"
        })
      end
    end

    context "Location" do
      let(:latitude)  { 51.502625 }
      let(:longitude) { -0.089951 }

      it 'should correctly identify a location through an array' do
        instance = Yo::Client::Yo.new("JOHNSNOW", [latitude, longitude])
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq({
          username: "JOHNSNOW",
          location: expected_location
        })
      end

      it 'should correctly identify a location through a hash' do
        instance = Yo::Client::Yo.new("JOHNSNOW", { lat: latitude, lng: longitude })
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq({
          username: "JOHNSNOW",
          location: expected_location
        })
      end

      it 'should correctly identify a location through a hash with different keys' do
        instance = Yo::Client::Yo.new("JOHNSNOW", { latitude: latitude, longitude: longitude })
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq({
          username: "JOHNSNOW",
          location: expected_location
        })
      end

      it 'should correctly identify a location through a string' do
        instance = Yo::Client::Yo.new("JOHNSNOW", "%s;%s" % [latitude, longitude])
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq({
          username: "JOHNSNOW",
          location: expected_location
        })
      end

      private

      def expected_location
        "%s;%s" % [latitude, longitude]
      end
    end
  end
end