FactoryBot.define do
  factory :yahoo_ads_integration, class: Spree::Integrations::YahooAds do
    active { true }
    preferred_yss_conversion_id { FFaker::Internet.password }
    preferred_yss_conversion_label { FFaker::Internet.password }
    store { Spree::Store.default }

    # 検索広告(YSS)に加えてディスプレイ広告(YDA)も設定する
    trait :with_yda do
      preferred_yda_conversion_id { FFaker::Internet.password }
      preferred_yda_conversion_label { FFaker::Internet.password }
    end

    # ディスプレイ広告(YDA)のみ設定する
    trait :yda_only do
      preferred_yss_conversion_id { nil }
      preferred_yss_conversion_label { nil }
      preferred_yda_conversion_id { FFaker::Internet.password }
      preferred_yda_conversion_label { FFaker::Internet.password }
    end
  end
end
