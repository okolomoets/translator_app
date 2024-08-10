class TranslationController
  def self.translate(params)
    text, to = params.values_at(:text, :to)

    raise ErrorHandler.new('Missing text or target language', 400) unless text && to
    
    { translation: TranslationService.call(text, to) }.to_json
  end
end
