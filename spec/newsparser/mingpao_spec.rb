# encoding: UTF-8

require 'spec_helper'

describe Newsparser::Mingpao do
  describe "#sections" do
    it "returns a hash with links and sections" do
      mingpao = Newsparser::Mingpao.new
      gaa1_htm = IO.read("spec/htmls/gaa1.htm")
      allow(mingpao).to receive(:get_url).and_return(gaa1_htm)
      result = mingpao.sections("20110718", "main.htm")
      # check only keys since values are chinese
      expect(result.first).to have_key(:link)
      expect(result.first).to have_value("gaindex.htm")
    end
  end

  describe "#sub_sections" do
    it "returns a hash with links and titles" do
      mingpao = Newsparser::Mingpao.new
      gaa1_htm = IO.read("spec/htmls/gaa1.htm")
      allow(mingpao).to receive(:article_link).and_return('gaa1.htm')
      allow(mingpao).to receive(:get_url).and_return(gaa1_htm)
      result = mingpao.sub_sections("20110718", "gaindex.htm")
      # check only keys since values are chinese
      expect(result.first).to have_key(:link)
      expect(result.first).to have_value("gaa1.htm")
    end
  end

  describe "#article" do
    it "returns a hash article title and content" do
      mingpao = Newsparser::Mingpao.new
      gaa1_htm = IO.read("spec/htmls/gaa1.htm")
      allow(mingpao).to receive(:get_url).and_return(gaa1_htm)
      result = mingpao.article("20110718", "gaa1.htm")
      # check only keys since values are chinese
      expect(result).to have_key(:title)
      expect(result).to have_key(:content)
    end
  end
end
