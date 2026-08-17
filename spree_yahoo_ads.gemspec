# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_yahoo_ads/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_yahoo_ads'
  s.version     = SpreeYahooAds::VERSION
  s.summary     = 'Yahoo! Ads conversion tracking extension for Spree Commerce'
  s.required_ruby_version = '>= 3.0'

  s.author    = 'be-agile'
  s.email     = 'dev@be-agile.jp'
  s.homepage  = 'https://github.com/be-agile/spree_yahoo_ads'
  s.license      = 'AGPL-3.0-or-later'

  s.files        = Dir["{app,config,db,lib,vendor}/**/{*,.*}", 'LICENSE', 'Rakefile', 'README.md'].reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_opts = '>= 5.1.0'
  s.add_dependency 'spree', spree_opts
  s.add_dependency 'spree_admin', spree_opts
  s.add_dependency 'spree_extension', '= 0.1.0'
  s.add_dependency 'spree_storefront', spree_opts
end
