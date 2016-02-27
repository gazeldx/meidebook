module BooksHelper
  def book_name(book)
    "《#{book.info['title'] || book.name || '未命名的书'}》"
  end

  def book_show_title(book)
    "公益图书<br>#{book_name(book)}"
  end
end