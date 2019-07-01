# frozen_string_literal: true

module Esputnik
  class Response
    def initialize(faraday_response)
      @raw_response = faraday_response
    end

    def success?
      @raw_response.success?
    end

    def json
      JSON.parse(@raw_response.body) if @raw_response.body.present?
    end

    def raw_body
      @raw_response.body
    end
  end
end
