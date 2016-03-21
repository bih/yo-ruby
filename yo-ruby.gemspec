# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yo-ruby/version'

Gem::Specification.new do |s|
  s.name        = 'yo-ruby'
  s.version     = Yo::VERSION
  s.licenses    = ['MIT']
  s.summary     = "An awesome Ruby wrapper for the Yo! mobile app."
  s.description = "Probably the most complex Ruby wrapper for the Yo app (justyo.co) that recently raised $1 million dollars."
  s.authors     = ["Bilawal Hameed"]
  s.email       = 'bilawal@studenthack.com'
  s.files       = ["lib/yo-ruby.rb"]
  s.homepage    = 'http://github.com/bih/yo-ruby'

  s.required_ruby_version = '>= 2.0.0'
  
  s.add_dependency "rspec", "~> 3.4"
  s.add_dependency "coveralls"
	s.add_dependency "rake"
  s.add_runtime_dependency "httparty", "~> 0.13"
end
