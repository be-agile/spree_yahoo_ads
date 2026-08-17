module SpreeYahooAds
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_yahoo_ads'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_yahoo_ads.environment', before: :load_config_initializers do |_app|
      SpreeYahooAds::Config = SpreeYahooAds::Configuration.new
    end

    initializer 'spree_yahoo_ads.assets' do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[spree_yahoo_ads_manifest]
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
