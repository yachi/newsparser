module Newsparser
  class Mingpao < Base
    BASE_URL = "http://news.mingpao.com/"

    def sections
    end

    def sub_sections(date_str=nil, section="gaa1.htm")
      date_str ||= today_str
      @link_and_titles = {}

      parse_html(BASE_URL + "#{date_str}/#{section}") do |doc|
        doc.css("#menu1 > option").each do |option|
          @link_and_titles[option["value"]] = option.content
        end
      end
      @link_and_titles
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
