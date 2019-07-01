# frozen_string_literal: true

require 'test_helper'

describe Esputnik::Client do
  before do
    @client = Esputnik::Client.new(login: 'email@example.com', password: 'secret', logger: Logger.new(STDOUT))
  end

  describe '#simple_contact_subscribe' do
    it 'works if channels are present' do
      VCR.use_cassette('subscribe_contact') do
        response = @client.simple_contact_subscribe(
          email: 'test123@example.com',
          phone: '+79160001122',
          additional_data: [{ id: 98_748, value: 'м' }]
        )

        assert response.success?
        assert_equal ({ 'id' => 564_407_320 }), response.json
      end
    end
  end

  describe '#simple_contact_update' do
    it 'updates user' do
      VCR.use_cassette('update_contact') do
        response = @client.simple_contact_update(
          id: 564_407_320,
          email: 'test123@example.com',
          phone: '+79160001122',
          additional_data: [{ id: 98_748, value: 'ж' }]
        )

        assert response.success?
        # sic! странно, но здесь вместо JSON в ответ приходит plain-text.
        assert_equal "Contact with id='564407320' has been updated", response.raw_body
      end
    end
  end

  describe '#send_event' do
    it 'sends new event if uniq key is provided' do
      VCR.use_cassette('send_event') do
        response = @client.send_event(event_type_key: 'test', key_value: 'test@example.com', params: { foo: 'bar' })

        assert response.success?
        refute response.json
      end
    end
  end
end
