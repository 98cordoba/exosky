namespace :invoke do
  desc "Import star data from a JSON file into the database"

  task stars: :environment do
    begin
      require 'json'

      file_path = 'db/seeding_files/star_database.json'

      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end

      file_contents = File.read(file_path)
      file_contents.gsub!('NaN', 'null')
      stars = JSON.parse(file_contents)

      stars.each do |star_data|
        puts "Importing star: #{star_data['source_id']}"
        begin
          star = Star.find_or_initialize_by(source: star_data['source_id'])

          star.dec = star_data['dec']
          star.mass_flame = star_data['mass_flame']
          star.parallax = star_data['parallax']
          star.phot_g_mean_mag = star_data['phot_g_mean_mag']
          star.ra = star_data['ra']

          if star.save
            puts "Imported star: #{star.source}"
          else
            puts "Failed to import star: #{star.source}, errors: #{star.errors.full_messages.join(', ')}"
          end
        rescue => e
          puts "Failed to import star: #{star_data['source_id']}, error: #{e.message}"
        end
      end
    rescue => e
      puts "ERROR MESSAGE: #{e}"
    end
  end
end