module Api
  module V1
    class BooksController < BaseController
      before_action :set_book, only: %i[show update destroy]

      def index
        books = Book.search(params[:author_name])
                    .order(updated_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])

        render_result('Books list', true, books, BookSerializer, build_meta_object(books))
      end

      def show
        render_object('Book detail', @book, BookSerializer)
      end

      def create
        @book = Book.new(book_params)

        if @book.save
          render_object('Created successfully', @book, BookSerializer)
        else
          render_error('Created failed', false, 422, @book.errors)
        end
      end

      def update
        if @book.update(book_params)
          render_object('Updated successfully', @book, BookSerializer)
        else
          render_error('Updated failed', false, 422, @book.errors)
        end
      end

      def destroy
        @book.destroy

        unless @book.persisted?
          render_sucess('Deleted successfully')
        else
          render_error('Deleted failed', false, 422)
        end
      end

      private

      def book_params
        params.permit(:title, :description, :price, :author_id)
      end

      def set_book
        @book = Book.find(params[:id])
      end
    end
  end
end
