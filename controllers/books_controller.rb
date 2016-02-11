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
      flash_errors(comment) if flash_errors(book).nil?
    end

    redirect "/#{params[:book_code]}"
  end

  get '/latest' do
    if admin?
      @books = Book.reverse_order(:created_at)
      slim :'/books/latest'
    end
  end

  get '/:id/refused' do
    if admin?
      book = Book[params[:id]]
      book.comments_dataset.delete
      book.bookusers_dataset.delete
      book.destroy
      flash[:notice] = "图书“#{book.code}” id=#{book.id}已被删除。"
      redirect '/books/latest'
    end
  end

  get '/claimers' do
    if admin?
      @bookusers = Bookuser.reverse_order(:created_at)
      slim :'/books/claimers'
    end
  end

  get '/verify_claim_:bookuser_id' do
    if admin?
      bookuser = Bookuser[params[:bookuser_id]]
      bookuser.book.update(user_id: current_user.id)
      Bookuser.where(book_id: bookuser.book_id).delete

      flash[:notice] = "#{bookuser.user.nickname || bookuser.user.username} 对 #{bookuser.book.code} 的认领已审核。"
      redirect '/books/claimers'
    end
  end

  get '/:book_code/claim' do
    @book = Book.find(code: params[:book_code])
    if @book.user_id.nil?
      Bookuser.create(book_id: @book.id, user_id: current_user.id, created_at: Time.now)
      flash[:notice] = "您对的本书的认领已经提交审核。如果本书中的捐书人手写笔记，和你捐的其它书的笔记相同，审核就会通过。"
    end

    redirect "/#{params[:book_code]}"
  end
end