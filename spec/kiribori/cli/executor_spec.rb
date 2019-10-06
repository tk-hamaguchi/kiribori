# frozen_string_literal: true

require 'rspec'

RSpec.describe Kiribori::CLI::Executor do
  subject(:described_instance) do
    obj = included_class.new
    obj.options = options
    obj.config  = config
    obj
  end

  let(:included_class) do
    Class.new do
      include Kiribori::CLI::Executor
      attr_accessor :options, :config
    end
  end
  let(:options) { { all: true } }
  let(:all_templates) { instance_double(Array) }
  let(:config) { { templates: { all: all_templates } } }

  context '#select_templates' do
    subject(:exec_select_templates) { described_instance.select_templates }

    context 'with options[:all]' do
      let(:options) { { all: true } }

      it { is_expected.to eq all_templates }
    end
  end

  context '#template_prefix' do
    subject(:exec_template_prefix) { described_instance.template_prefix }

    it do
      expect(exec_template_prefix).to eq <<~TEMPLATE
        # encoding: UTF-8
        # frozen_string_literal: true

        def source_paths
          [Rails.root]
        end

        def app_class
          app_name.camelize.constantize.const_get(:Application)
        end

        ENV['DISABLE_SPRING'] = '1'
        ENV['BUNDLE_IGNORE_MESSAGES'] = '1'
      TEMPLATE
    end
  end
end
