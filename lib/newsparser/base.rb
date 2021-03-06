require 'httparty'
require 'nokogiri'
module Newsparser
  class Base
    include HTTParty

    private
    def parse_html(url, options={}, &block)
      charset = options.delete(:charset)
      html = get_url(url, options)
      if charset
        html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      end
      yield(Nokogiri::HTML(html))
    end

    def get_url(url, options)
      options[:headers] ||= {}
      options[:headers]["accept-encoding"] = "deflate, gzip"
      ua = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; HTC-A9191/1.0; zh-cn) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16"
      options[:headers].merge!({"User-Agent" => ua}){|k, v1, v2| v1} # reverse_merge!
      response = self.class.get(url, options)
      response.body.to_s
    end
  end
end
