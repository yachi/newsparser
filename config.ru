$:.unshift './lib'
require 'rubygems'
require 'api/server'

if ENV['RACK_ENV'] == "development"
  require 'awesome_print'
  require 'hirb'
  require 'hirb-unicode'
  Object.send :include, Hirb::Console
end
map '/api' do
  use Rack::Deflater
  run Api::Server
end
