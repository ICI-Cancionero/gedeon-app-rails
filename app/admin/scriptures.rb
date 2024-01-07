require 'bible_parser'

ActiveAdmin.register Scripture do
  permit_params :book_id, :chapter_num, :content, verses: []

  form partial: 'form'

  controller do
    before_action :set_bible
    before_action :parse_verses, only: [:create]

    def set_bible
      bible_path = Rails.root.join("lib/open-bibles/spa-rv1909.usfx.xml")
      @bible = BibleParser.new(File.open(bible_path))
    end

    def parse_verses
      if params[:scripture] && params[:scripture][:verses]
        params[:scripture][:verses] = params[:scripture][:verses].split(",")
      end
    end
  end

  collection_action :chapters, method: :get do
    @chapters = []

    if params[:book_id]
      book = @bible.books.find{|book| book.id == params[:book_id]}
    end

    book = @bible.books.first if book.nil?

    @chapters = book.chapters.map do |chapter|
      {
        chapter_num: chapter.num,
        book_title: chapter.book_title
      }
    end

    respond_to do |format|
      format.json { render json: @chapters }
    end
  end

  collection_action :verses, method: :get do
    @verses = []

    if params[:book_id]
      book = @bible.books.find{|book| book.id == params[:book_id]}
    end

    if params[:chapter_num]
      chapter = book.chapters.find{|chapter| chapter.num == params[:chapter_num].to_i }
    end

    book = @bible.books.first if book.nil?
    chapter = book.chapters.first if chapter.nil?

    @verses = chapter.verses.map do |verse|
      {
        num: verse.num,
        book_id: verse.book_id,
        book_title: verse.book_title,
        chapter_num: verse.chapter_num,
        text: verse.text
      }
    end

    respond_to do |format|
      format.json { render json: @verses }
    end
  end
end
