# Required according to the command-line tool.
gem 'minitest'

# Load in the test.
require 'minitest/autorun'
require 'minitest/spec'

# And the source of yo-ruby, of course.
FileList['lib/**/*.rb'].each{ |source| load(source) }

# Let the tests begin!
class YoRubyTest < Minitest::Test

  # Don't allow a invalid API key
  def test_if_wrong_api_key_is_accepted
    fake_key_value = "eqnwenwqe"

    begin
      Yo.api_key = fake_key_value
      api_key = Yo.api_key
    rescue YoException => e
      api_key = ""
    end

    # Does not equal.
    refute_equal api_key, fake_key_value, "Yo.api_key wrongly accepted #{fake_key_value} as a valid API key"
  end

  # Allow a valid API key
  def test_if_valid_api_key_is_accepted
    real_key_value = "abcdefgh-ijkl-mnop-qrst-uvwxyz012345"

    begin
      Yo.api_key = real_key_value
      api_key = Yo.api_key
    rescue YoException => e
      api_key = ""
    end

    assert_equal api_key, real_key_value, "Yo.api_key does not accept a valid Yo API key"
  end

  # TODO: More tests.
end