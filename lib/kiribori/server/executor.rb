# frozen_string_literal: true

class Kiribori::Server

  # サーバー用メインロジック
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module Executor
    def execute!(templates = option.templates)
      [
        '200',
        { 'Content-Type' => 'application/x-thor-template' },
        [Kiribori::TemplateBuilder.build!(templates)]
      ]
    rescue StandardError => e
      handle_error(e)
    end

    private

    def handle_error(err)
      logger.error(([[err.class, err.message].join(' : ')] + err.backtrace).join("\n"))
      [
        '500',
        { 'Content-Type' => 'text/plain' },
        [err.message]
      ]
    end
  end
end
