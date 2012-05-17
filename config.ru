$:.unshift './lib'
require 'rubygems'
require 'api/server'

if $rack and $rack.env == "development"
  require 'awesome_print'
end
run Api::Server
