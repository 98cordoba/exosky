class CreateExoplanets < ActiveRecord::Migration[7.1]
  def change
    create_table :exoplanets do |t|
      t.string :pl_name                  # Planet Name
      t.string :hostname                 # Host Name
      t.integer :default_flag            # Default Parameter Set
      t.string :disposition              # Archive Disposition
      t.string :disp_refname             # Archive Disposition Reference
      t.integer :sy_snum                 # Number of Stars
      t.integer :sy_pnum                 # Number of Planets
      t.string :discoverymethod          # Discovery Method
      t.integer :disc_year               # Discovery Year
      t.string :disc_facility            # Discovery Facility
      t.string :soltype                  # Solution Type
      t.integer :pl_controv_flag         # Controversial Flag
      t.string :pl_refname               # Planetary Parameter Reference
      t.float :pl_orbper                 # Orbital Period [days]
      t.float :pl_orbpererr1             # Orbital Period Upper Uncertainty [days]
      t.float :pl_orbpererr2             # Orbital Period Lower Uncertainty [days]
      t.integer :pl_orbperlim            # Orbital Period Limit Flag
      t.float :pl_orbsmax                # Orbit Semi-Major Axis [au]
      t.float :pl_orbsmaxerr1            # Orbit Semi-Major Axis Upper Uncertainty [au]
      t.float :pl_orbsmaxerr2            # Orbit Semi-Major Axis Lower Uncertainty [au]
      t.integer :pl_orbsmaxlim           # Orbit Semi-Major Axis Limit Flag
      t.float :pl_rade                   # Planet Radius [Earth Radius]
      t.float :pl_radeerr1               # Planet Radius Upper Uncertainty [Earth Radius]
      t.float :pl_radeerr2               # Planet Radius Lower Uncertainty [Earth Radius]
      t.integer :pl_radelim              # Planet Radius Limit Flag
      t.float :pl_radj                   # Planet Radius [Jupiter Radius]
      t.float :pl_radjerr1               # Planet Radius Upper Uncertainty [Jupiter Radius]
      t.float :pl_radjerr2               # Planet Radius Lower Uncertainty [Jupiter Radius]
      t.integer :pl_radjlim              # Planet Radius Limit Flag
      t.float :pl_bmasse                 # Planet Mass or Mass*sin(i) [Earth Mass]
      t.float :pl_bmasseerr1             # Planet Mass or Mass*sin(i) [Earth Mass] Upper Uncertainty
      t.float :pl_bmasseerr2             # Planet Mass or Mass*sin(i) [Earth Mass] Lower Uncertainty
      t.integer :pl_bmasselim            # Planet Mass or Mass*sin(i) [Earth Mass] Limit Flag
      t.float :pl_bmassj                 # Planet Mass or Mass*sin(i) [Jupiter Mass]
      t.float :pl_bmassjerr1             # Planet Mass or Mass*sin(i) [Jupiter Mass] Upper Uncertainty
      t.float :pl_bmassjerr2             # Planet Mass or Mass*sin(i) [Jupiter Mass] Lower Uncertainty
      t.integer :pl_bmassjlim            # Planet Mass or Mass*sin(i) [Jupiter Mass] Limit Flag
      t.string :pl_bmassprov             # Planet Mass Provenance
      t.float :pl_orbeccen               # Orbital Eccentricity
      t.float :pl_orbeccenerr1           # Eccentricity Upper Uncertainty
      t.float :pl_orbeccenerr2           # Eccentricity Lower Uncertainty
      t.integer :pl_orbeccenlim          # Eccentricity Limit Flag
      t.float :pl_insol                  # Insolation Flux [Earth Flux]
      t.float :pl_insolerr1              # Insolation Flux Upper Uncertainty [Earth Flux]
      t.float :pl_insolerr2              # Insolation Flux Lower Uncertainty [Earth Flux]
      t.integer :pl_insollim             # Insolation Flux Limit Flag
      t.float :pl_eqt                    # Equilibrium Temperature [K]
      t.float :pl_eqterr1                # Equilibrium Temperature Upper Uncertainty [K]
      t.float :pl_eqterr2                # Equilibrium Temperature Lower Uncertainty [K]
      t.integer :pl_eqtlim               # Equilibrium Temperature Limit Flag
      t.integer :ttv_flag                # Transit Timing Variation Flag
      t.string :st_refname               # Stellar Parameter Reference
      t.string :st_spectype              # Spectral Type
      t.float :st_teff                   # Stellar Effective Temperature [K]
      t.float :st_tefferr1               # Stellar Effective Temperature Upper Uncertainty [K]
      t.float :st_tefferr2               # Stellar Effective Temperature Lower Uncertainty [K]
      t.integer :st_tefflim              # Stellar Effective Temperature Limit Flag
      t.float :st_rad                    # Stellar Radius [Solar Radius]
      t.float :st_raderr1                # Stellar Radius Upper Uncertainty [Solar Radius]
      t.float :st_raderr2                # Stellar Radius Lower Uncertainty [Solar Radius]
      t.integer :st_radlim               # Stellar Radius Limit Flag
      t.float :st_mass                   # Stellar Mass [Solar Mass]
      t.float :st_masserr1               # Stellar Mass Upper Uncertainty [Solar Mass]
      t.float :st_masserr2               # Stellar Mass Lower Uncertainty [Solar Mass]
      t.integer :st_masslim              # Stellar Mass Limit Flag
      t.float :st_met                    # Stellar Metallicity [dex]
      t.float :st_meterr1                # Stellar Metallicity Upper Uncertainty [dex]
      t.float :st_meterr2                # Stellar Metallicity Lower Uncertainty [dex]
      t.integer :st_metlim               # Stellar Metallicity Limit Flag
      t.string :st_metratio              # Stellar Metallicity Ratio
      t.float :st_logg                   # Stellar Surface Gravity [log10(cm/s^2)]
      t.float :st_loggerr1               # Stellar Surface Gravity Upper Uncertainty [log10(cm/s^2)]
      t.float :st_loggerr2               # Stellar Surface Gravity Lower Uncertainty [log10(cm/s^2)]
      t.integer :st_logglim              # Stellar Surface Gravity Limit Flag
      t.string :sy_refname               # System Parameter Reference
      t.string :rastr                    # RA [sexagesimal]
      t.float :ra                        # RA [deg]
      t.string :decstr                   # Dec [sexagesimal]
      t.float :dec                       # Dec [deg]
      t.float :sy_dist                   # Distance [pc]
      t.float :sy_disterr1               # Distance [pc] Upper Uncertainty
      t.float :sy_disterr2               # Distance [pc] Lower Uncertainty
      t.float :sy_vmag                   # V (Johnson) Magnitude
      t.float :sy_vmagerr1               # V Magnitude Upper Uncertainty
      t.float :sy_vmagerr2               # V Magnitude Lower Uncertainty
      t.float :sy_kmag                   # Ks (2MASS) Magnitude
      t.float :sy_kmagerr1               # Ks Magnitude Upper Uncertainty
      t.float :sy_kmagerr2               # Ks Magnitude Lower Uncertainty
      t.float :sy_gaiamag                # Gaia Magnitude
      t.float :sy_gaiamagerr1            # Gaia Magnitude Upper Uncertainty
      t.float :sy_gaiamagerr2            # Gaia Magnitude Lower Uncertainty
      t.date :rowupdate                  # Date of Last Update
      t.date :pl_pubdate                 # Planetary Parameter Reference Publication Date
      t.date :releasedate                # Release Date

      t.timestamps
    end
  end
end
