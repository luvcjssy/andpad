module Api
  module V1
    class AuthorsController < BaseController
      before_action :set_author, only: %i[show update destroy]

      def index
        authors = Author.includes(:books)
                        .order(updated_at: :desc)
                        .paginate(page: params[:page], per_page: params[:per_page])

        render_result('Author list', true, authors, AuthorSerializer, build_meta_object(authors))
      end

      def show
        render_object('Author detail', @author, AuthorSerializer)
      end

      def create
        @author = Author.new(author_params)

        if @author.save
          render_object('Created successfully', @author, AuthorSerializer)
        else
          render_error('Created failed', false, 422, @author.errors)
        end
      end

      def update
        if @author.update(author_params)
          render_object('Updated successfully', @author, AuthorSerializer)
        else
          render_error('Updated failed', false, 422, @author.errors)
        end
      end

      def destroy
        @author.destroy

        unless @author.persisted?
          render_sucess('Deleted successfully')
        else
          render_error('Deleted failed', false, 422)
        end
      end

      private

      def author_params
        params.permit(:name, :bio)
      end

      def set_author
        @author = Author.find(params[:id])
      end
    end
  end
end
