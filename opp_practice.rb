# 本モデル
class Book < ApplicationRecord
  belongs_to :author
  class << self
    def create_book_with_author(args)
      # 本にはISBNという番号が割りふられる。ここではその番号を自動で取得してくれるサービスがあるとする
      isbn = Faraday.get('/isbn_publish_service')
      Author.create(name: args[:author_name]).books.create(name: args[:name], title: args[:title], isbn: isbn)
    end
  end
end

# 著者モデル
class Author < ApplicationRecord
  has_many :books
end

class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  #
  # params = { book: [ :title, :author_name, :published_at] }
  # みたいになっているとする
  #
  def create
    book = Book.create_book_with_author(params)
    redirect_to :show, notice: "#{book.title}/#{book.author.name} を追加しました"
  end

  private

  def params
    params.require(:book).permit(:title, :published_at, :author_name)
  end
end
