module Newsparser
  class Mingpao < Base
    BASE_URL = "http://news.mingpao.com/"
    CHARSET = "big5-hkscs"

    def sections(date_str=nil, section="main.htm")
      date_str ||= today_str
      result = returning([]) do |result|
        parse_html(BASE_URL + "#{date_str}/#{section}", {:charset => CHARSET}) do |doc|
          doc.css("#rlink > a").each do |a_tag|
            result << returning({}) do |hash|
              hash[:link] = a_tag["href"]
              hash[:title] = a_tag.content
            end
          end
        end
      end.reject!{|x| x[:link] == "main.htm"}
      result
    end

    def sub_sections(date_str=nil, section="gaindex.htm")
      date_str ||= today_str
      result = returning([]) do |result|
        link = article_link(date_str, section)
        parse_html(BASE_URL + "#{date_str}/#{link}", {:charset => CHARSET}) do |doc|
          doc.css("#menu1 > option").each do |option|
            result << returning({}) do |hash|
              hash[:link] = option["value"]
              hash[:title] = option.content
            end
          end
        end
      end
    end

    def article(date_str=nil, section="gaa1.htm")
      date_str ||= today_str
      result = returning({}) do |result|
        parse_html(BASE_URL + "#{date_str}/#{section}", {:charset => CHARSET}) do |doc|
          doc.css("h1").each do |h1|
            result[:title] = h1.content
          end
          doc.css("div.content_medium").each do |div|
            result[:content] ||= []
            result[:content] << div.inner_html
          end
        end
      end
    end

    private
    def article_link(date_str, section)
      parse_html(BASE_URL + "#{date_str}/#{section}", {:charset => CHARSET}) do |doc|
        doc.css("h1 > a").each do |a_tag|
          return a_tag[:href]
        end
      end
    end

    def today_str
      # Treat HKT 5AM as a new day
      (Time.now.utc - 3 * 3600).strftime('%Y%m%d')
    end

    def base_uri
      @base_uri ||= URI.parse(BASE_URL)
    end
  end
end
