require 'spec_helper'

RSpec.describe Yo::Client::Subscribers do
  subject { Yo::Client::Subscribers.new }

  context "Methods" do
    it { expect(subject).to respond_to(:count) }
    it { expect(subject).not_to respond_to(:http_request) }
  end
end