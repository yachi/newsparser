# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "newsparser/version"

Gem::Specification.new do |s|
  s.name        = "newsparser"
  s.version     = Newsparser::VERSION
  s.authors     = ["Yachi Lo"]
  s.email       = ["yaachi@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{news parser}
  s.description = %q{an extensible news parser}

  s.rubyforge_project = "newsparser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency 'nokogiri'
  s.add_dependency "httparty"

  # API dependencies
  s.add_dependency "sinatra"
  s.add_dependency "oj"
  s.add_dependency "multi_json"
  s.add_dependency "dalli"
end
