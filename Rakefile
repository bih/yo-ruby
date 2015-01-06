# The simple test loader for yo-ruby. Woohoo!
task :test do
  $LOAD_PATH.unshift('lib', 'spec')
  Dir.glob('./spec/**/*_spec.rb') { |f| require f }
end

task :console do
  load "lib/yo-ruby.rb"

  require "ripl"
  Ripl.start({ binding: binding })
end