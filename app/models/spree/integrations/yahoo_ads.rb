module Spree
  module Integrations
    # Yahoo!広告のコンバージョン計測(JSタグ方式)を Store 単位で有効化する Integration。
    #
    # - サイトジェネラルタグ(head)   … yclid をファーストパーティ Cookie(_ycl_yjad)に捕捉
    # - コンバージョン測定タグ(完了時) … 検索広告(YSS) / ディスプレイ広告(YDA)
    #
    # 検索広告(YSS)とディスプレイ広告(YDA)はタグの type / パラメータ名が異なる。
    # それぞれ独立して設定でき、両方設定した場合は完了時に2種類のコンバージョンを発火する。
    #   - YSS: yss_conversion / yahoo_conversion_id / yahoo_conversion_label
    #   - YDA: ydn_conversion / yahoo_ydn_conv_io / yahoo_ydn_conv_label
    class YahooAds < Spree::Integration
      preference :yss_conversion_id, :string
      preference :yss_conversion_label, :string
      preference :yda_conversion_id, :string
      preference :yda_conversion_label, :string

      # ID とラベルは「両方セット」か「両方空」のいずれか(片方だけの入力を防ぐ)。
      validates :preferred_yss_conversion_label, presence: true, if: -> { preferred_yss_conversion_id.present? }
      validates :preferred_yss_conversion_id, presence: true, if: -> { preferred_yss_conversion_label.present? }
      validates :preferred_yda_conversion_label, presence: true, if: -> { preferred_yda_conversion_id.present? }
      validates :preferred_yda_conversion_id, presence: true, if: -> { preferred_yda_conversion_label.present? }

      # YSS・YDA の少なくとも一方が完全設定されていること。
      validate :at_least_one_ad_type_configured

      def self.integration_name
        Spree.t('admin.integrations.yahoo_ads.name', default: 'Yahoo Ads')
      end

      def self.integration_group
        'analytics'
      end

      def self.icon_path
        'integration_icons/yahoo-ads-logo.png'
      end

      def yss_configured?
        preferred_yss_conversion_id.present? && preferred_yss_conversion_label.present?
      end

      def yda_configured?
        preferred_yda_conversion_id.present? && preferred_yda_conversion_label.present?
      end

      # 設定済みの広告種別ごとに、コンバージョン測定タグ(ytag)の { type:, config: } を返す。
      # YSS のみ→1件、YDA のみ→1件、両方→2件、未設定→空配列。value には注文金額を渡す。
      def conversion_tags(value: nil)
        tags = []

        if yss_configured?
          tags << {
            type: 'yss_conversion',
            config: {
              'yahoo_conversion_id'    => preferred_yss_conversion_id,
              'yahoo_conversion_label' => preferred_yss_conversion_label,
              'yahoo_conversion_value' => value.to_s
            }
          }
        end

        if yda_configured?
          tags << {
            type: 'ydn_conversion',
            config: {
              'yahoo_ydn_conv_io'    => preferred_yda_conversion_id,
              'yahoo_ydn_conv_label' => preferred_yda_conversion_label,
              'yahoo_ydn_conv_value' => value.to_s
            }
          }
        end

        tags
      end

      private

      def at_least_one_ad_type_configured
        return if yss_configured? || yda_configured?

        errors.add(:base, Spree.t('admin.integrations.yahoo_ads.at_least_one_required'))
      end
    end
  end
end
