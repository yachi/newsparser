module Newsparser
  class Base
    include HTTParty
    def parse_html(url, options={}, &block)
      response = self.class.get(url, options)
      html = response.body.to_s
      if charset = options[:charset]
        html = Iconv.iconv('utf-8//IGNORE', charset, html).join("")
      end
      yield(Nokogiri::HTML(html))
    end
  end
end
