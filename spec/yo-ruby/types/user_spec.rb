require 'spec_helper'

RSpec.describe Yo::User do
  let!(:user) { Yo::User.new(example_user) }

  context "Validations" do
    context "Values" do
      it { expect(user.display_name).to eq("John Snow") }
      it { expect(user.first_name).to eq("John") }
      it { expect(user.last_name).to eq("Snow") }
      it { expect(user.is_api_user).to eq(false) }
      it { expect(user.is_subscribable).to eq(false) }
      it { expect(user.name).to eq("John Snow") }
      it { expect(user.needs_location).to eq(true) }
      it { expect(user.photo).to eq("http://www.google.com/images/logo.gif") }
      it { expect(user.type).to eq("user") }
      it { expect(user.user_id).to eq(100) }
      it { expect(user.username).to eq("JOHNSNOW") }
      it { expect(user.yo_count).to eq(500) }
    end

    context "Methods" do
      it { expect(user.display_name?).to be_truthy }
      it { expect(user.first_name?).to be_truthy }
      it { expect(user.last_name?).to be_truthy }
      it { expect(user.is_api_user?).to be_falsey }
      it { expect(user.is_subscribable?).to be_falsey }
      it { expect(user.name?).to be_truthy }
      it { expect(user.needs_location?).to be_truthy }
      it { expect(user.photo?).to be_truthy }
      it { expect(user.type?).to be_truthy }
      it { expect(user.user_id?).to be_truthy }
      it { expect(user.username?).to be_truthy }
      it { expect(user.yo_count?).to be_truthy }
    end
  end

  private

  def example_user
    {
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
  end
end