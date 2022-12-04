# 本モデル
class Book < ApplicationRecord
  belongs_to :author
  before_save do
    # 本にはISBNという番号が割りふられる。ここではその番号を自動で取得してくれるサービスがあるとする
    self.isbn = Faraday.get('/isbn_publish_service')
  end
end

# 著者モデル
class Author < ApplicationRecord
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
    author = Author.create!(name: params[:book][:author_name])
    book = Book.new(title: params[:book][:title], published_at: params[:book][:published_at])
    book.author = author
    book.save!
    redirect_to :show, notice: "#{book.title}/#{author.name} を追加しました"
  end
end
  