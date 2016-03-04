module BooksHelper
  def book_name(book)
    "《#{book.info['title'] || book.name || '未命名的书'}》"
  end

  def book_show_title(book)
    book_name(book)
  end
end