module Newsparser
  class Mingpao < Base
    BASE_URL = "http://news.mingpao.com/"

    def sections(date_str=nil, section="main.htm")
      result = returning({}) do |hash|
        parse_html(BASE_URL + "#{date_str}/#{section}") do |doc|
          doc.css("#rlink > a").each do |a_tag|
            hash[a_tag["href"]] = a_tag.content
          end
        end
      end
      result.reject!{|k, v| k == "main.htm"}
      result
    end

    def sub_sections(date_str=nil, section="gaa1.htm")
      date_str ||= today_str
      @link_and_titles = returning({}) do |hash|
        parse_html(BASE_URL + "#{date_str}/#{section}") do |doc|
          doc.css("#menu1 > option").each do |option|
            hash[option["value"]] = option.content
          end
        end
      end
    end

    def menu
    end

    private
    def today_str
      # Treat HKT 5AM as a new day
      (Time.now.utc - 3 * 3600).strftime('%Y%m%d')
    end

    def base_uri
      @base_uri ||= URI.parse(BASE_URL)
    end
  end
end
