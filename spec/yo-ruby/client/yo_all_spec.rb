require 'spec_helper'

RSpec.describe Yo::Client::Yo do
  context "Validations" do
    context "Initializations" do
      it 'should not raise error with one parameters' do
        expect { Yo::Client::YoAll.new("http://google.com") }.not_to raise_error
        expect { Yo::Client::YoAll.new([0, 0]) }.not_to raise_error
        expect { Yo::Client::YoAll.new({ lat: 0, lng: 0 }) }.not_to raise_error
        expect { Yo::Client::YoAll.new({ latitude: 0, longitude: 0 }) }.not_to raise_error
        expect { Yo::Client::YoAll.new("0;0") }.not_to raise_error
      end
    end

    context "Methods" do
      subject { Yo::Client::YoAll.new }

      it { expect(subject).to respond_to(:as_response) }
      it { expect(subject).not_to respond_to(:http_request) }
    end

    context "Links" do
      it 'should correctly identify a http link' do
        instance = Yo::Client::YoAll.new("http://www.google.com")
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq(link: "http://www.google.com")
      end

      it 'should correctly identify a https link' do
        instance = Yo::Client::YoAll.new("https://www.google.com")
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq(link: "https://www.google.com")
      end
    end

    context "Location" do
      let(:latitude)  { 51.502625 }
      let(:longitude) { -0.089951 }

      it 'should correctly identify a location through an array' do
        instance = Yo::Client::YoAll.new([latitude, longitude])
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq(location: expected_location)
      end

      it 'should correctly identify a location through a hash' do
        instance = Yo::Client::YoAll.new({ lat: latitude, lng: longitude })
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq(location: expected_location)
      end

      it 'should correctly identify a location through a hash with different keys' do
        instance = Yo::Client::YoAll.new({ latitude: latitude, longitude: longitude })
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq(location: expected_location)
      end

      it 'should correctly identify a location through a string' do
        instance = Yo::Client::YoAll.new("%s;%s" % [latitude, longitude])
        parameters = instance.instance_variable_get(:@parameters)
        
        expect(parameters).to eq(location: expected_location)
      end

      private

      def expected_location
        "%s;%s" % [latitude, longitude]
      end
    end
  end
end