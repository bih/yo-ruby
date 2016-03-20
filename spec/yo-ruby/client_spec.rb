require 'spec_helper'

RSpec.describe Yo do
  context "Methods" do
    it { expect(Yo).to respond_to(:yo!) }
    it { expect(Yo).to respond_to(:link!) }
    it { expect(Yo).to respond_to(:location!) }
    it { expect(Yo).to respond_to(:all!) }
    it { expect(Yo).to respond_to(:subscribers) }
  end
end