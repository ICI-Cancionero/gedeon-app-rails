module HomeHelper
  def grouped_songs
    @songs.group_by {|song| song.title.first.upcase }
  end
end
