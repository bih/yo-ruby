require 'spec_helper'

RSpec.describe do
  context "Validations" do
    it { expect(Yo).to be_const_defined(:VERSION) }
  end
end