class BooksController < ApplicationController
  post '/' do
    book = Book.new(code: params[:book_code],
                    created_at: Time.now,
                    updated_at: Time.now)

    if book.valid?
      book.save

      comment = Comment.new(book_id: book.id,
                            photo: params[:photo],
                            created_at: Time.now,
                            updated_at: Time.now)
      comment.save

      redirect "/#{params[:book_code]}"
    else
      flash[:body] = params[:body]
      flash_errors(book)
      redirect "/#{params[:book_code]}"
    end
  end
end