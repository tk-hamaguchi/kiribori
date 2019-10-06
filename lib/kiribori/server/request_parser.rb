# frozen_string_literal: true

class Kiribori::Server

  # サーバー用リクエストパーサー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module RequestParser

    attr_reader :option

    def parse(env)
      @env    = env
      @option = Kiribori::Option.new(symbolized_params)
    end

    private

    def symbolized_params
      req = Rack::Request.new(@env)
      simbolized_hash_from(req.params).merge(path_to_group(req.path))
    end

    def path_to_group(path)
      case path
      when '/'
        { all: false, group: :default }
      when '/all'
        { all: true, group: :all }
      else
        { all: false, group: nil }
      end
    end

    def simbolized_hash_from(hash)
      JSON.parse(hash.to_json, symbolize_names: true)
    end
  end
end
