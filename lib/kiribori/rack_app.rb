# frozen_string_literal: true

module Kiribori

  # Rackアプリ
  class RackApp
    def call(env)
      Kiribori::Server.execute!(env)
    end
  end
end
