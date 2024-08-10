require 'rack/test'
require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'
require_relative '../app'

Dotenv.load('.env.test')
ENV['RACK_ENV'] ||= 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:all) do
    Cache.instance.client.flushdb
  end

  config.after(:all) do 
    Cache.instance.client.flushdb
  end
end

def app
  TranslatorApp
end
