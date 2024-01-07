namespace :subdomains do
  desc 'Creates ICI Santiago Subdomain'
  task create_ici_santiago: :environment do
    ActiveRecord::Base.transaction do
      ici_santiago = Account.find_or_create_by!(name: "ICI Santiago", subdomain: "ici-santiago")
      puts "Creating Account: #{ici_santiago.name} id: #{ici_santiago.id} subdomain: #{ici_santiago.subdomain}"

      ActsAsTenant.without_tenant do
        puts "updating Songs count: #{Song.where(account_id: nil).count}"
        Song.where(account_id: nil).update_all(account_id: ici_santiago.id)
        puts "updating Playlists count: #{Playlist.where(account_id: nil).count}"
        Playlist.where(account_id: nil).update_all(account_id: ici_santiago.id)
        puts "updating AdminUser count: #{AdminUser.where(account_id: nil).count}"
        AdminUser.where(account_id: nil).update_all(account_id: ici_santiago.id)
      end
    end
  end
end
