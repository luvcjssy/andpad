require 'rails_helper'

describe Api::V1::AuthorsController do
  describe 'GET #index' do
    context 'valid request' do
      before :each do
        create_list(:author, 15)
      end

      it 'returns status 200' do
        get :index
        expect(response).to have_http_status 200
      end

      it 'return 10 authors' do
        get :index
        body = JSON.parse(response.body)
        expect(body['data'].count).to eq 10
      end

      it 'return 5 authors on page 5' do
        get :index, params: { page: 2 }
        body = JSON.parse(response.body)
        expect(body['current_page']).to eq 2
        expect(body['data'].count).to eq 5
      end
    end
  end

  describe 'GET #show' do
    context 'valid request' do
      let(:author) { create(:author, name: 'Author Demo') }

      it 'returns status 200' do
        get :show, params: { id: author.id }
        expect(response).to have_http_status 200
      end

      it 'return author detail' do
        get :show, params: { id: author.id }
        body = JSON.parse(response.body)
        expect(body['data']['name']).to eq 'Author Demo'
      end
    end

    context 'invalid request' do
      it 'returns status 404' do
        get :show, params: { id: 1000 }
        expect(response).to have_http_status 404
      end
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, body: author_params.to_json, as: :json }

    context 'valid params' do
      let(:author_params) { { name: 'Author 1', bio: 'Author Bio 1' } }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'created successfully' do
        action
        body = JSON.parse(response.body)
        expect(body['data']['name']).to eq 'Author 1'
        expect(body['data']['bio']).to eq 'Author Bio 1'
      end
    end

    context 'invalid params' do
      let(:author_params) { { name: '', bio: 'Author Bio 2' } }

      it 'returns missing data' do
        action
        expect(response).to have_http_status 422
      end
    end
  end

  describe 'PUT #update' do
    let(:action) { put :update, params: { id: author_id }, body: { name: name_attr }.to_json, as: :json }

    context 'valid params' do
      let(:name_attr) { 'Author Updated 1' }
      let(:author) { create(:author) }
      let(:author_id) { author.id }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'updated successfully' do
        action
        body = JSON.parse(response.body)
        expect(body['data']['name']).to eq 'Author Updated 1'
      end
    end

    context 'invalid params' do
      let(:name_attr) { '' }
      let(:author) { create(:author) }
      let(:author_id) { author.id }

      it 'returns missing data' do
        action
        expect(response).to have_http_status 422
      end

      it 'returns status 404' do
        put :update, params: { id: 999 }, body: { name: 'Author Updated' }.to_json, as: :json
        expect(response).to have_http_status 404
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:action) { delete :destroy, params: { id: author_id } }

    context 'valid params' do
      let(:author) { create(:author) }
      let(:author_id) { author.id }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'deleted successfully' do
        action
        expect(Author.count).to eq 0
      end
    end

    context 'invalid params' do
      it 'returns record not found' do
        delete :destroy, params: { id: 99 }
        expect(response).to have_http_status 404
      end
    end
  end
end