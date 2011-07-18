module Newsparser
  class Base
    include HTTParty

    private
    def parse_html(url, options={}, &block)
      charset = options.delete(:charset)
      html = get_url(url, options)
      if charset
        html = Iconv.iconv('utf-8//IGNORE', charset, html).join("")
      end
      yield(Nokogiri::HTML(html))
    end

    def get_url(url, options)
      response = self.class.get(url, options)
      response.body.to_s
    end
  end
end
