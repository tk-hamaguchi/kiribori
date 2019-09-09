# frozen_string_literal: true

RSpec.describe Kiribori::TemplateParser do
  context 'class' do
    subject { described_class }

    it { is_expected.to respond_to :parse! }

    context '.parse!' do
      subject { described_class.parse! params }

      let(:params) { double }

      it { is_expected.to eq true }
    end
  end

  context 'when condition' do
    it 'succeeds' do
      pending 'Not implemented'
    end
  end
end
