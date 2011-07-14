require 'newsparser'
require 'newsparser/mingpao'

require 'sinatra/base'
require 'yajl'
require 'api/mingpao'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
  end
end
