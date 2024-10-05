namespace :invoke do
  desc "Import exoplanet data from a CSV file into the database"

  task exoplanets: :environment do
    require 'csv'

    file_path = 'db/seeding_files/exoplanets.csv'

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit
    end

    CSV.foreach(file_path, headers: true, col_sep: ',') do |row|
      puts "Importing exoplanet: #{row['pl_name']}"
      begin
        exoplanet = Exoplanet.find_or_initialize_by(pl_name: row['pl_name'], hostname: row['hostname'])

        exoplanet.update(
          default_flag: row['default_flag'],
          disposition: row['disposition'],
          disp_refname: row['disp_refname'],
          sy_snum: row['sy_snum'],
          sy_pnum: row['sy_pnum'],
          discoverymethod: row['discoverymethod'],
          disc_year: row['disc_year'],
          disc_facility: row['disc_facility'],
          soltype: row['soltype'],
          pl_controv_flag: row['pl_controv_flag'],
          pl_refname: row['pl_refname'],
          pl_orbper: row['pl_orbper'],
          pl_orbpererr1: row['pl_orbpererr1'],
          pl_orbpererr2: row['pl_orbpererr2'],
          pl_orbperlim: row['pl_orbperlim'],
          pl_orbsmax: row['pl_orbsmax'],
          pl_orbsmaxerr1: row['pl_orbsmaxerr1'],
          pl_orbsmaxerr2: row['pl_orbsmaxerr2'],
          pl_orbsmaxlim: row['pl_orbsmaxlim'],
          pl_rade: row['pl_rade'],
          pl_radeerr1: row['pl_radeerr1'],
          pl_radeerr2: row['pl_radeerr2'],
          pl_radelim: row['pl_radelim'],
          pl_radj: row['pl_radj'],
          pl_radjerr1: row['pl_radjerr1'],
          pl_radjerr2: row['pl_radjerr2'],
          pl_radjlim: row['pl_radjlim'],
          pl_bmasse: row['pl_bmasse'],
          pl_bmasseerr1: row['pl_bmasseerr1'],
          pl_bmasseerr2: row['pl_bmasseerr2'],
          pl_bmasselim: row['pl_bmasselim'],
          pl_bmassj: row['pl_bmassj'],
          pl_bmassjerr1: row['pl_bmassjerr1'],
          pl_bmassjerr2: row['pl_bmassjerr2'],
          pl_bmassjlim: row['pl_bmassjlim'],
          pl_bmassprov: row['pl_bmassprov'],
          pl_orbeccen: row['pl_orbeccen'],
          pl_orbeccenerr1: row['pl_orbeccenerr1'],
          pl_orbeccenerr2: row['pl_orbeccenerr2'],
          pl_orbeccenlim: row['pl_orbeccenlim'],
          pl_insol: row['pl_insol'],
          pl_insolerr1: row['pl_insolerr1'],
          pl_insolerr2: row['pl_insolerr2'],
          pl_insollim: row['pl_insollim'],
          pl_eqt: row['pl_eqt'],
          pl_eqterr1: row['pl_eqterr1'],
          pl_eqterr2: row['pl_eqterr2'],
          pl_eqtlim: row['pl_eqtlim'],
          ttv_flag: row['ttv_flag'],
          st_refname: row['st_refname'],
          st_spectype: row['st_spectype'],
          st_teff: row['st_teff'],
          st_tefferr1: row['st_tefferr1'],
          st_tefferr2: row['st_tefferr2'],
          st_tefflim: row['st_tefflim'],
          st_rad: row['st_rad'],
          st_raderr1: row['st_raderr1'],
          st_raderr2: row['st_raderr2'],
          st_radlim: row['st_radlim'],
          st_mass: row['st_mass'],
          st_masserr1: row['st_masserr1'],
          st_masserr2: row['st_masserr2'],
          st_masslim: row['st_masslim'],
          st_met: row['st_met'],
          st_meterr1: row['st_meterr1'],
          st_meterr2: row['st_meterr2'],
          st_metlim: row['st_metlim'],
          st_metratio: row['st_metratio'],
          st_logg: row['st_logg'],
          st_loggerr1: row['st_loggerr1'],
          st_loggerr2: row['st_loggerr2'],
          st_logglim: row['st_logglim'],
          sy_refname: row['sy_refname'],
          rastr: row['rastr'],
          ra: row['ra'],
          decstr: row['decstr'],
          dec: row['dec'],
          sy_dist: row['sy_dist'],
          sy_disterr1: row['sy_disterr1'],
          sy_disterr2: row['sy_disterr2'],
          sy_vmag: row['sy_vmag'],
          sy_vmagerr1: row['sy_vmagerr1'],
          sy_vmagerr2: row['sy_vmagerr2'],
          sy_kmag: row['sy_kmag'],
          sy_kmagerr1: row['sy_kmagerr1'],
          sy_kmagerr2: row['sy_kmagerr2'],
          sy_gaiamag: row['sy_gaiamag'],
          sy_gaiamagerr1: row['sy_gaiamagerr1'],
          sy_gaiamagerr2: row['sy_gaiamagerr2'],
          rowupdate: row['rowupdate'],
          pl_pubdate: row['pl_pubdate'],
          releasedate: row['releasedate']
        )

        puts "Imported exoplanet: #{exoplanet.pl_name}"
      rescue => e
        puts "Failed to import exoplanet: #{row['pl_name']}, error: #{e.message}"
      end
    end
  end
end