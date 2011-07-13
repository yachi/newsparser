# encoding: UTF-8

require 'spec_helper'

describe Newsparser do
  describe "#sections" do
    it "returns a hash with links and sections" do
      mingpao = Newsparser::Mingpao.new
      gaa1_htm = IO.read("spec/htmls/gaa1.htm")
      mingpao.stub(:parse_html).and_yield(Nokogiri::HTML(gaa1_htm))
      result = mingpao.sections("20110711", "main.htm")
      # check only keys since values are chinese
      result.should have_key("gaindex.htm")
      result.should have_key("gbindex.htm")
    end
  end

  describe "#sub_sections" do
    it "returns a hash with links and titles" do
      mingpao = Newsparser::Mingpao.new
      gaa1_htm = IO.read("spec/htmls/gaa1.htm")
      mingpao.stub(:parse_html).and_yield(Nokogiri::HTML(gaa1_htm))
      result = mingpao.sub_sections("20110711", "gaa1.htm")
      # check only keys since values are chinese
      result.should have_key("gaa1.htm")
    end
  end
end
