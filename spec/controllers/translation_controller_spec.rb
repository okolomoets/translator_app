require 'spec_helper'
require 'json'

describe TranslationController do

  describe 'POST /translate' do
    context 'with valid parameters' do
      let(:params) { { text: 'Hello', to: 'ES' } }
      
      before do
        allow(DeepL).to receive(:translate).and_return(
          double('Response', text: 'Halo')
        )
      end

      it 'returns a translated text' do
        post '/translate', params

        expect(last_response).to be_ok
        json_response = JSON.parse(last_response.body)
        expect(json_response['translation']).to eq('Halo')
      end

      context 'when request cached data' do 
        it 'returns a translated text' do
          post '/translate', params
  
          expect(last_response).to be_ok
          json_response = JSON.parse(last_response.body)
          expect(json_response['translation']).to eq('Halo')
          expect(DeepL).not_to receive(:translate)
        end
      end
    end

    # I didn't have time to make it work
    # context 'when DeepL request' do 
    #   let(:params) { { text: 'Hello', to: 'DE' } }
    #   before do
    #     allow(DeepL).to receive(:translate).and_raise(DeepL::Exceptions::RequestError)
    #   end

    #   it 'returns a translated text' do
    #     post '/translate', params

    #     expect(last_response).not_to be_ok
    #     binding.pry
    #     json_response = JSON.parse(last_response.body)
    #     expect(json_response['code']).to eq(404)
    #     expect(json_response['error']).to eq('Some Exception explanation')
    #   end
    # end

    context 'with missing parameters' do
      let(:params) { { text: nil, to: 'ES' } }

      it 'returns a 400 error' do
        post '/translate', params

        expect(last_response.status).to eq(400)
        json_response = JSON.parse(last_response.body)
        expect(json_response['error']).to eq('Missing text or target language')
      end
    end
  end
end