require './config/cache'
require 'deepl'

class TranslationService
  def self.call(text, to)
    self.new(text, to).call
  end

  def initialize(text, to)
    @text = text
    @to = to
    @cache = Cache.instance.client
  end

  def call
    return cached_result if cached_result
    
    begin
      translation = DeepL.translate(text, nil, to.upcase).text
      cache.set(cache_key, translation)
      translation
    rescue DeepL::Exceptions::RequestError => error
      raise ErrorHandler.new(error.exception.message, error.response.code)
    end
  end

  private

  attr_reader :text, :to, :cache

  def cached_result
    @cached_result ||= cache.get(cache_key)
  end

  def cache_key
    "translation:#{decoded(text)}:#{decoded(to)}"
  end

  def decoded(string)
    Digest::MD5.hexdigest(string)
  end
end