class CommentsController < ApplicationController
  post '/' do
    book = Book.find(code: params[:book_code])
    comment = Comment.new(body: params[:body],
                          photo: params[:photo],
                          book_id: book.id,
                          user_id: session[:user_id] || nil,
                          created_at: Time.now,
                          updated_at: Time.now)

    if comment.valid?
      comment.save
    else
      flash[:body] = params[:body]
      flash_errors(comment)
    end

    redirect "/#{params[:book_code]}"
  end
end