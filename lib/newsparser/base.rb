module Newsparser
  class Base
    include HTTParty
    def parse_html(url, options={}, &block)
      response = self.class.get(url, options)
      yield(Nokogiri::HTML(response.body))
    end
  end
end
