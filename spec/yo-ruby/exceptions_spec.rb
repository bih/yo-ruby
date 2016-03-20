require 'spec_helper'

RSpec.describe do
  it 'should have all exceptions' do
    expect(Yo::YoApiKeyMustEqual36CharactersException).to be_a_kind_of(Class).and be < Exception
    expect(Yo::YoCannotHttpWithoutApiTokenException).to be_a_kind_of(Class).and be < Exception
    expect(Yo::YoUserNotFound).to be_a_kind_of(Class).and be < Exception
    expect(Yo::YoRateLimitExceeded).to be_a_kind_of(Class).and be < Exception
  end
end