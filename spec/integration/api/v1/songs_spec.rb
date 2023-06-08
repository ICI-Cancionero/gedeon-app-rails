require 'swagger_helper'

describe Api::V1::SongsController do

  path '/api/v1/songs' do
    get 'Retrieves songs' do
      tags 'Songs'
      consumes 'application/json'
      produces 'application/json'
      let!(:songs) { FactoryBot.create_list(:song, 3) }

      response '200', :success do
        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response.count).to eql(Song.all.count)
        end
      end
    end
  end

  path '/api/v1/songs/{id}' do
    get 'Retrieves a song' do
      tags 'Songs'
      consumes 'application/json'
      produces 'application/json'

      let!(:id) { FactoryBot.create(:song).id }
      parameter name: :id, in: :path, type: :string

      response '200', 'Song found' do

        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response["id"]).to eql(id)
        end
      end
    end
  end
end
