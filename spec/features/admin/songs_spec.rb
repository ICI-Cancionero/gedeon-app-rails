require 'rails_helper'

RSpec.feature 'Admin/Songs', type: :feature do
  include_context 'authenticated admin with subdomain'

  describe 'creating a song' do
    scenario 'can create a song with title, content, and author' do
      visit new_admin_song_path

      fill_in 'Title', with: 'Amazing Grace'
      fill_in 'Content', with: 'Amazing grace how sweet the sound'
      fill_in 'Author', with: 'John Newton'
      fill_in 'Position', with: '1'

      click_button 'Create Song'

      expect(page).to have_text('Song was successfully created')
      expect(page).to have_text('Amazing Grace')
      expect(page).to have_text('Amazing grace how sweet the sound')
      expect(page).to have_text('John Newton')
    end

    scenario 'can create a song with a YouTube video link', :js do
      visit new_admin_song_path

      fill_in 'Title', with: 'Worship Song'
      fill_in 'Content', with: 'Lyrics here'
      fill_in 'Author', with: 'Test Author'

      click_button 'Create Song'

      # After creation, go to edit page to add video link
      click_link 'Edit Song'

      # Add video link using has_many form
      find('a', text: /Add New/).click

      # Wait for the new fields to appear and fill them
      within('.has_many_fields:last-of-type') do
        select 'Youtube', from: 'Provider'
        fill_in 'Url', with: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
      end

      click_button 'Update Song'

      expect(page).to have_text('Song was successfully updated')
      expect(VideoLink.last.video_id).to eq('dQw4w9WgXcQ')
    end
  end

  describe 'updating a song' do
    let!(:song) { Song.create!(title: 'Old Title', content: 'Old content', author: 'Old Author', position: 1) }

    scenario 'can update title, content, and author' do
      visit edit_admin_song_path(song)

      fill_in 'Title', with: 'New Title'
      fill_in 'Content', with: 'New content here'
      fill_in 'Author', with: 'New Author'

      click_button 'Update Song'

      expect(page).to have_text('Song was successfully updated')
      expect(page).to have_text('New Title')
      expect(page).to have_text('New content here')
      expect(page).to have_text('New Author')

      song.reload
      expect(song.title).to eq('New Title')
      expect(song.content).to eq('New content here')
      expect(song.author).to eq('New Author')
    end

    scenario 'can add a video link to existing song', :js do
      visit edit_admin_song_path(song)

      find('a', text: /Add New/).click

      # Wait for the new fields to appear and fill them
      within('.has_many_fields:last-of-type') do
        select 'Youtube', from: 'Provider'
        fill_in 'Url', with: 'https://youtu.be/dQw4w9WgXcQ'
      end

      click_button 'Update Song'

      expect(page).to have_text('Song was successfully updated')

      song.reload
      expect(song.video_links.count).to eq(1)
      expect(song.video_links.first.provider).to eq('youtube')
      expect(song.video_links.first.video_id).to eq('dQw4w9WgXcQ')
    end
  end

  describe 'exporting songs as FreeShow zip' do
    scenario 'downloads a zip file containing all songs as txt files' do
      Song.create!(title: 'Amazing Grace', content: 'Amazing grace how sweet the sound',
                   author: 'John Newton', position: 1)
      Song.create!(title: 'Holy Holy Holy', content: 'Holy holy holy Lord God Almighty',
                   author: 'Reginald Heber', position: 2)

      visit admin_songs_path

      expect(page).to have_link('Download for FreeShow')

      click_link 'Download for FreeShow'

      expect(page.response_headers['Content-Type']).to eq('application/zip')
      expect(page.response_headers['Content-Disposition']).to include('songs_freeshow.zip')

      # Parse the zip and verify contents
      zip_content = page.body
      entries = {}
      Zip::InputStream.open(StringIO.new(zip_content)) do |zip|
        while (entry = zip.get_next_entry)
          entries[entry.name] = zip.read
        end
      end

      expect(entries).to have_key('Amazing Grace.txt')
      expect(entries).to have_key('Holy Holy Holy.txt')
      expect(entries['Amazing Grace.txt']).to eq('Amazing grace how sweet the sound')
      expect(entries['Holy Holy Holy.txt']).to eq('Holy holy holy Lord God Almighty')
    end

    context 'when a song title contains invalid filename characters' do
      scenario 'sanitizes the filename' do
        Song.create!(title: 'What/Why?', content: 'Special content', position: 3)

        visit export_txt_zip_admin_songs_path

        zip_content = page.body
        entries = {}
        Zip::InputStream.open(StringIO.new(zip_content)) do |zip|
          while (entry = zip.get_next_entry)
            entries[entry.name] = zip.read
          end
        end

        expect(entries).to have_key('What_Why_.txt')
        expect(entries['What_Why_.txt']).to eq('Special content')
      end
    end

    context 'when a song has a blank title' do
      scenario 'uses a fallback filename with the song id' do
        song = Song.create!(title: '', content: 'No title content', position: 4)

        visit export_txt_zip_admin_songs_path

        zip_content = page.body
        entries = {}
        Zip::InputStream.open(StringIO.new(zip_content)) do |zip|
          while (entry = zip.get_next_entry)
            entries[entry.name] = zip.read
          end
        end

        expect(entries).to have_key("song_#{song.id}.txt")
        expect(entries["song_#{song.id}.txt"]).to eq('No title content')
      end
    end
  end

  describe 'viewing song detail page with embedded video' do
    let!(:song) { Song.create!(title: 'Test Song', content: 'Test content', author: 'Test Author', position: 1) }
    let!(:video_link) { VideoLink.create!(provider: 'youtube', url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ') }

    before do
      song.video_links << video_link
    end

    scenario 'displays embedded YouTube video on show page' do
      visit admin_song_path(song)

      expect(page).to have_text('Test Song')
      expect(page).to have_text('Test content')
      expect(page).to have_text('Test Author')

      # Check that video embed iframe is present
      expect(page).to have_css('iframe[src*="youtube.com/embed/dQw4w9WgXcQ"]')
    end
  end
end
