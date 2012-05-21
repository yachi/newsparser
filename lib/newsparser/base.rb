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
      options[:headers] ||= {}
      ua = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; HTC-A9191/1.0; zh-cn) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16"
      options[:headers].merge!({"User-Agent" => ua}){|k, v1, v2| v1}
      response = self.class.get(url, options)
      response.body.to_s
    end
  end
end
