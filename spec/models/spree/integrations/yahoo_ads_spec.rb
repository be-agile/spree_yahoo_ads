require 'spec_helper'

RSpec.describe Spree::Integrations::YahooAds, type: :model do
  describe '.integration_group' do
    subject { described_class.integration_group }
    it { is_expected.to eq 'analytics' }
  end

  describe '.icon_path' do
    subject { described_class.icon_path }
    it { is_expected.to eq 'integration_icons/yahoo-ads-logo.png' }
  end

  describe '.integration_key' do
    subject { described_class.integration_key }
    it { is_expected.to eq 'yahoo_ads' }
  end

  describe 'validations' do
    subject { integration }

    let(:integration) do
      described_class.new(
        store: Spree::Store.new,
        preferred_yss_conversion_id: yss_id,
        preferred_yss_conversion_label: yss_label,
        preferred_yda_conversion_id: yda_id,
        preferred_yda_conversion_label: yda_label
      )
    end
    let(:yss_id) { nil }
    let(:yss_label) { nil }
    let(:yda_id) { nil }
    let(:yda_label) { nil }

    before { subject.valid? }

    context 'YSSのみ設定' do
      let(:yss_id) { 'ID' }
      let(:yss_label) { 'LABEL' }
      it { expect(subject.errors[:base]).to be_empty }
      it { expect(subject.errors[:preferred_yss_conversion_id]).to be_empty }
      it { expect(subject.errors[:preferred_yss_conversion_label]).to be_empty }
    end

    context 'YDAのみ設定' do
      let(:yda_id) { 'IO' }
      let(:yda_label) { 'LABEL' }
      it { expect(subject.errors[:base]).to be_empty }
    end

    context 'YSS/YDA両方設定' do
      let(:yss_id) { 'ID' }
      let(:yss_label) { 'LABEL' }
      let(:yda_id) { 'IO' }
      let(:yda_label) { 'LABEL2' }
      it { expect(subject.errors[:base]).to be_empty }
    end

    context '両方未設定' do
      it { expect(subject.errors[:base]).to be_present }
    end

    context 'YSSのIDのみ(ラベル欠落)' do
      let(:yss_id) { 'ID' }
      it { expect(subject.errors[:preferred_yss_conversion_label]).to be_present }
    end

    context 'YSSのラベルのみ(ID欠落)' do
      let(:yss_label) { 'LABEL' }
      it { expect(subject.errors[:preferred_yss_conversion_id]).to be_present }
    end

    context 'YDAのIDのみ(ラベル欠落)' do
      let(:yda_id) { 'IO' }
      it { expect(subject.errors[:preferred_yda_conversion_label]).to be_present }
    end

    context 'YDAのラベルのみ(ID欠落)' do
      let(:yda_label) { 'LABEL' }
      it { expect(subject.errors[:preferred_yda_conversion_id]).to be_present }
    end
  end

  describe '#yss_configured?' do
    subject { integration.yss_configured? }

    let(:integration) do
      described_class.new(preferred_yss_conversion_id: id, preferred_yss_conversion_label: label)
    end

    context 'ID・ラベルが揃っている' do
      let(:id) { 'ID' }
      let(:label) { 'LABEL' }
      it { is_expected.to be true }
    end

    context 'ラベルが欠落' do
      let(:id) { 'ID' }
      let(:label) { nil }
      it { is_expected.to be false }
    end
  end

  describe '#yda_configured?' do
    subject { integration.yda_configured? }

    let(:integration) do
      described_class.new(preferred_yda_conversion_id: id, preferred_yda_conversion_label: label)
    end

    context 'ID・ラベルが揃っている' do
      let(:id) { 'IO' }
      let(:label) { 'LABEL' }
      it { is_expected.to be true }
    end

    context 'IDが欠落' do
      let(:id) { nil }
      let(:label) { 'LABEL' }
      it { is_expected.to be false }
    end
  end

  describe '#conversion_tags' do
    subject { integration.conversion_tags(value: 1234.0) }

    let(:integration) do
      described_class.new(
        preferred_yss_conversion_id: yss_id,
        preferred_yss_conversion_label: yss_label,
        preferred_yda_conversion_id: yda_id,
        preferred_yda_conversion_label: yda_label
      )
    end
    let(:yss_id) { nil }
    let(:yss_label) { nil }
    let(:yda_id) { nil }
    let(:yda_label) { nil }

    context 'YSSのみ設定' do
      let(:yss_id) { 'ID' }
      let(:yss_label) { 'LABEL' }
      it {
        is_expected.to eq([
                            { type: 'yss_conversion',
                              config: { 'yahoo_conversion_id' => 'ID',
                                        'yahoo_conversion_label' => 'LABEL',
                                        'yahoo_conversion_value' => '1234.0' } }
                          ])
      }
    end

    context 'YDAのみ設定' do
      let(:yda_id) { 'IO' }
      let(:yda_label) { 'LABEL' }
      it {
        is_expected.to eq([
                            { type: 'ydn_conversion',
                              config: { 'yahoo_ydn_conv_io' => 'IO',
                                        'yahoo_ydn_conv_label' => 'LABEL',
                                        'yahoo_ydn_conv_value' => '1234.0' } }
                          ])
      }
    end

    context 'YSS/YDA両方設定' do
      let(:yss_id) { 'ID' }
      let(:yss_label) { 'YSSLABEL' }
      let(:yda_id) { 'IO' }
      let(:yda_label) { 'YDALABEL' }
      it { expect(subject.map { |t| t[:type] }).to eq(%w[yss_conversion ydn_conversion]) }
    end

    context '未設定' do
      it { is_expected.to eq [] }
    end
  end
end
