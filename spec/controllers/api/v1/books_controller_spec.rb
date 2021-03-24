require 'rails_helper'

describe Api::V1::BooksController do
  describe 'GET #index' do
    context 'valid request' do
      before :each do
        create_list(:book, 10)
        create_list(:book, 5, author_id: create(:author, name: 'Author').id)
      end

      it 'returns status 200' do
        get :index
        expect(response).to have_http_status 200
      end

      it 'return 10 books' do
        get :index
        body = JSON.parse(response.body)
        expect(body['data'].count).to eq 10
      end

      it 'return 5 books on page 5' do
        get :index, params: { page: 2 }
        body = JSON.parse(response.body)
        expect(body['current_page']).to eq 2
        expect(body['data'].count).to eq 5
      end

      it 'filter with author name = author' do
        get :index, params: { author_name: 'author' }
        body = JSON.parse(response.body)
        expect(body['data'].count).to eq 5
      end
    end
  end

  describe 'GET #show' do
    context 'valid request' do
      let(:book) { create(:book, title: 'Book Demo', author_id: create(:author).id) }

      it 'returns status 200' do
        get :show, params: { id: book.id }
        expect(response).to have_http_status 200
      end

      it 'return book detail' do
        get :show, params: { id: book.id }
        body = JSON.parse(response.body)
        expect(body['data']['title']).to eq 'Book Demo'
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
    let(:action) { post :create, body: body_params.to_json, as: :json }

    context 'valid params' do
      let(:body_params) { { title: 'Book 1', description: 'Book desc 1', author_id: create(:author).id } }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'created successfully' do
        action
        body = JSON.parse(response.body)
        expect(body['data']['title']).to eq 'Book 1'
        expect(body['data']['description']).to eq 'Book desc 1'
      end
    end

    context 'invalid params' do
      let(:body_params) { { title: '', description: 'Book desc 2' } }

      it 'returns missing data' do
        action
        expect(response).to have_http_status 422
      end

      it 'returns author not found' do
        post :create, body: { title: 'Book 1', author_id: 999 }.to_json, as: :json
        expect(response).to have_http_status 422
      end
    end
  end

  describe 'PUT #update' do
    let(:action) { put :update, params: { id: book_id }, body: { title: title_attr }.to_json, as: :json }

    context 'valid params' do
      let(:title_attr) { 'Book Updated 1' }
      let(:book) { create(:book) }
      let(:book_id) { book.id }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'updated successfully' do
        action
        body = JSON.parse(response.body)
        expect(body['data']['title']).to eq 'Book Updated 1'
      end
    end

    context 'invalid params' do
      let(:title_attr) { '' }
      let(:book) { create(:book) }
      let(:book_id) { book.id }

      it 'returns missing data' do
        action
        expect(response).to have_http_status 422
      end

      it 'returns status 404' do
        put :update, params: { id: 999 }, body: { title: 'Book Updated' }.to_json, as: :json
        expect(response).to have_http_status 404
      end

      it 'returns author not found' do
        put :update, params: { id: 999 }, body: { author_id: 999 }.to_json, as: :json
        expect(response).to have_http_status 404
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:action) { delete :destroy, params: { id: book_id } }

    context 'valid params' do
      let(:book) { create(:book) }
      let(:book_id) { book.id }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'deleted successfully' do
        action
        expect(Book.count).to eq 0
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