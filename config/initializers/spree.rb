Rails.application.config.after_initialize do
  Rails.application.config.spree.integrations << Spree::Integrations::YahooAds

  if Rails.application.config.respond_to?(:spree_storefront)
    # サイトジェネラルタグ(全ページ head、yclid 捕捉)
    Rails.application.config.spree_storefront.head_partials << 'spree_yahoo_ads/head'

    # コンバージョン測定タグ(注文完了時、注文金額を埋め込み)
    Rails.application.config.spree_storefront.checkout_complete_partials << 'spree_yahoo_ads/checkout_complete'
  end
end
