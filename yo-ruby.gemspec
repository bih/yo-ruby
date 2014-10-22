Gem::Specification.new do |s|
  s.name        = 'yo-ruby'
  s.version     = '0.1.4'
  s.licenses    = ['MIT']
  s.summary     = "An awesome Ruby wrapper for the Yo! mobile app."
  s.description = "Probably the most complex Ruby wrapper for the Yo app (justyo.co) that recently raised $1 million dollars."
  s.authors     = ["Bilawal Hameed"]
  s.email       = 'bilawal@studenthack.com'
  s.files       = ["lib/yo-ruby.rb"]
  s.homepage    = 'http://github.com/bih/yo-ruby'
  
  s.add_dependency "httparty", ">= 0.13.1"
end