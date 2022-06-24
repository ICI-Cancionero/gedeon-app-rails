namespace :songs do
	SONGS_CSV_PATH = Rails.root.join('db', 'seeds', 'songs.csv')

	desc 'Import songs from CSV'
  task import: :environment do
    ActiveRecord::Base.transaction do
      CSV.foreach(SONGS_CSV_PATH, headers: true, col_sep: ',') do |row|

        Song.create!(
        	title: row['title'],
        	content: row['content'],
        	position: row['position'].to_i
        )
      end
    end
  end

  desc 'Sort songs by title'
  task sort_by_title: :environment do
    ActiveRecord::Base.transaction do
      Song.all.order(title: :asc).each_with_index do |song, index|
        puts "Song title: #{song.title} position: #{song.position} updated_position: #{index + 1}"

        song.update(position: index + 1)
      end
    end
  end
end