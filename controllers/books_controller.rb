class BooksController < ApplicationController
  post '/' do
    book = Book.new(code: params[:book_code],
                    created_at: Time.now,
                    updated_at: Time.now)

    comment = Comment.new(book_id: 1,
                          photo: params[:photo],
                          created_at: Time.now,
                          updated_at: Time.now)

    if book.valid? && comment.valid?
      book.save

      comment.book_id = book.id
      comment.save

      flash[:notice] = "您的图书已经登记，等侍审核中。"
      add_received_books(params[:book_code])
    else
      flash[:body] = params[:body]
      flash_errors(book)
      flash_errors(comment)
    end

    redirect "/#{params[:book_code]}"
  end
end