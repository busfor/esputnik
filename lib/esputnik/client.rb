# frozen_string_literal: true

module Esputnik
  class Client
    BASE_URL = 'https://esputnik.com/api/v1'

    def initialize(login:, password:, logger: nil)
      @login = login
      @password = password
      @logger = logger
    end

    def version
      get '/version'
    end

    def send_event(event_type_key:, key_value:, params: {})
      post '/event',
           'eventTypeKey' => event_type_key,
           'keyValue' => key_value,
           'params' => wrap_key_value(params)
    end

    # Метод, упрощающий работу с API eSputnik
    # additional_data - [{id: <key_id>, value: value}, ... ]

    def simple_contact_subscribe(email:, phone:, additional_data:)
      contact = Esputnik::Contact.new
      contact.channels = channels_pair(email: email, phone: phone)
      contact.fields = additional_data

      contact_subscribe(contact: contact)
    end

    def simple_contact_update(id:, email:, phone:, additional_data:)
      contact = Esputnik::Contact.new
      contact.channels = channels_pair(email: email, phone: phone)
      contact.fields = additional_data

      contact_update(id: id, contact: contact)
    end

    # Метод применяется для подключения форм подписки и в других случаях.
    # Создает новые контакты, существующие обновляет. Создает в системе события для запуска сценариев.
    # Новые контакты создаются в статусе "неподтвержденный", что позволяет реализовать double opt-in.

    def contact_subscribe(contact:, groups: nil, form_type: nil)
      raise Error, 'Esputnik::Contact expected' unless contact.is_a?(Esputnik::Contact)
      raise Error, contact.errors unless contact.valid?

      post '/contact/subscribe',
           'contact' => contact.as_json,
           'groups' => groups,
           'formType' => form_type
    end

    # Метод для обновления одного контакта. Новые контакты не создает.
    # Чтобы обновить контакт этим методом надо знать id контакта в нашей системе. Подробнее.

    def contact_update(id:, contact:, groups: nil, form_type: nil)
      raise Error, 'Esputnik::Contact expected' unless contact.is_a?(Esputnik::Contact)
      raise Error, contact.errors unless contact.valid?

      put "/contact/#{id}",
          'contact' => contact.as_json,
          'groups' => groups,
          'formType' => form_type
    end

    private

    def channels_pair(email:, phone:)
      [
        Esputnik::Channel.new.tap do |c|
          c.type = 'email'
          c.value = email
        end,
        Esputnik::Channel.new.tap do |c|
          c.type = 'sms'
          c.value = phone
        end
      ]
    end

    def get(path, **data)
      send_request(:get, path, data)
    end

    def post(path, data)
      send_request(:post, path, data)
    end

    def put(path, data)
      send_request(:put, path, data)
    end

    def send_request(method, path, data)
      response = http_client.send(method, BASE_URL + path) do |req|
        req.body = data.to_json if data.any?
        req.headers['Content-Type'] = 'application/json'
        req.headers['Accept'] = 'application/json'
      end

      Response.new(response)
    end

    def http_client
      @http_client ||= build_http_client
    end

    def build_http_client
      connection = Faraday.new do |builder|
        builder.request :url_encoded
        builder.response :logger, @logger, bodies: true if @logger
        builder.adapter Faraday.default_adapter
      end

      connection.basic_auth(@login, @password)
      connection
    end

    def wrap_key_value(hash)
      hash.each_with_object([]) { |(k, v), list| list << { name: k, value: v } }
    end
  end
end
