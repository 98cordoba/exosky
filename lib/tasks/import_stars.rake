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
      stars = JSON.parse(file_contents)
      
      stars.each do |star|
        puts "Importing star: #{star['source_id']}"
        begin
          star = Star.find_or_initialize_by(source_id: star['source_id'])
          star.dec = star_data['dec'].nan? ? nil : star_data['dec']
          star.mass_flame = star_data['mass_flame'].nan? ? nil : star_data['mass_flame']
          star.parallax = star_data['parallax'].nan? ? nil : star_data['parallax']
          star.phot_g_mean_mag = star_data['phot_g_mean_mag'].nan? ? nil : star_data['phot_g_mean_mag']
          star.ra = star_data['ra'].nan? ? nil : star_data['ra']
          star.source_id = star_data['source_id']

            if star.save!
              puts "Imported star: #{star.source_id}"
            else
              puts "Failed to import star: #{star['source_id']}, error: #{star.error}"
            end
        end
      end
    rescue => e 
      puts "ERROR MESSAGE: #{e}"
    end
  end
end