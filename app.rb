require 'pry'
require 'sinatra/base'
require 'dotenv/load'
require './controllers/translation_controller'
require './services/translation_service'
require './config/error_handler'
require './config/deepl'

class TranslatorApp < Sinatra::Base
  configure do
    set :show_exceptions, false
    enable :logging
  end 
  
  post '/translate' do
    TranslationController.translate(params)
  end

  error ErrorHandler do
    content_type :json
    status env['sinatra.error'].code
    { error: env['sinatra.error'].message }.to_json
  end
  
  run! if app_file == $0
end
