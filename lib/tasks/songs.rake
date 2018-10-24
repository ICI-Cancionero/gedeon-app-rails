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
end