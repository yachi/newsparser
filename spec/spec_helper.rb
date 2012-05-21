require 'rubygems'
require 'bundler/setup'

require 'newsparser'

# for debug in test
require 'awesome_print'
require 'hirb'
require 'hirb-unicode'
Object.send :include, Hirb::Console

RSpec.configure do |config|
end
