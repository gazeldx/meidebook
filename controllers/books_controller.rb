class BooksController < ApplicationController
  get '/' do
    @user_count = Book.where('user_id IS NOT NULL').distinct.select(:user_id).count
    @books = Book.where('user_id IS NOT NULL').reverse_order(:id)
    slim :'/books/index'
  end

  post '/' do
    book = Book.new(code: params[:book_code],
                    name: params[:name],
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

  post '/:id/update_isbn' do
    if admin?
      book = Book[params[:id]]
      book.update(isbn: params[:isbn])

      invoke_douban_book(book.isbn)

      flash[:notice] = "图书“#{book.code}” 《#{book.name}》 id=#{book.id} 的ISBN已更新。"
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
      bookuser.book.update(user_id: bookuser.user_id)
      Bookuser.where(book_id: bookuser.book_id).delete

      flash[:notice] = "#{bookuser.user.nickname || bookuser.user.username} 对 #{bookuser.book.code} 的认领已审核。"
      redirect '/books/claimers'
    end
  end

  get '/:book_code/claim' do
    @book = Book.find(code: params[:book_code])
    if @book.user_id.nil?
      Bookuser.create(book_id: @book.id, user_id: current_user.id, created_at: Time.now)
      flash[:notice] = "认领已提交审核。如本书捐书人手写笔记，和你捐的其它书的笔记相同，审核就会通过。"
    end

    redirect "/#{params[:book_code]}"
  end

  # 注意: 本方法应该放在最后
  get '/:id' do
    @book = Book[params[:id]]
    slim :'/books/show_by_id'
  end

  def invoke_douban_book(isbn)
    conn = Faraday.new(url: 'https://api.douban.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    # begin
      res = conn.get do |req|
        req.url "/v2/book/isbn/#{isbn}"
        req.options.timeout = 4
        req.options.open_timeout = 2
      end

      JSON.parse(res.body)

      booklet = Booklet[isbn] || (Booklet.unrestrict_primary_key; Booklet.new(id: isbn, created_at: Time.now))
      booklet.douban_message = res.body
      booklet.updated_at = Time.now
      booklet.save
    # rescue Exception => exception
    #   flash[:error] = "调用 /isbn 接口时，遇到了异常：#{exception.to_s}！请联系统管理员。"
    # end
  end
end