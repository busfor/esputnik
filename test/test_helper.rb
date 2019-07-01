# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'esputnik'
require 'vcr'

require 'webmock/minitest'
require 'minitest/autorun'

VCR.configure do |config|
  config.before_record do |item|
    item.response.body.force_encoding('UTF-8')
  end

  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
end
