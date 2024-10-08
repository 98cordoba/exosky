# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_06_053344) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exoplanets", force: :cascade do |t|
    t.string "pl_name"
    t.string "hostname"
    t.integer "default_flag"
    t.string "disposition"
    t.string "disp_refname"
    t.integer "sy_snum"
    t.integer "sy_pnum"
    t.string "discoverymethod"
    t.integer "disc_year"
    t.string "disc_facility"
    t.string "soltype"
    t.integer "pl_controv_flag"
    t.string "pl_refname"
    t.float "pl_orbper"
    t.float "pl_orbpererr1"
    t.float "pl_orbpererr2"
    t.integer "pl_orbperlim"
    t.float "pl_orbsmax"
    t.float "pl_orbsmaxerr1"
    t.float "pl_orbsmaxerr2"
    t.integer "pl_orbsmaxlim"
    t.float "pl_rade"
    t.float "pl_radeerr1"
    t.float "pl_radeerr2"
    t.integer "pl_radelim"
    t.float "pl_radj"
    t.float "pl_radjerr1"
    t.float "pl_radjerr2"
    t.integer "pl_radjlim"
    t.float "pl_bmasse"
    t.float "pl_bmasseerr1"
    t.float "pl_bmasseerr2"
    t.integer "pl_bmasselim"
    t.float "pl_bmassj"
    t.float "pl_bmassjerr1"
    t.float "pl_bmassjerr2"
    t.integer "pl_bmassjlim"
    t.string "pl_bmassprov"
    t.float "pl_orbeccen"
    t.float "pl_orbeccenerr1"
    t.float "pl_orbeccenerr2"
    t.integer "pl_orbeccenlim"
    t.float "pl_insol"
    t.float "pl_insolerr1"
    t.float "pl_insolerr2"
    t.integer "pl_insollim"
    t.float "pl_eqt"
    t.float "pl_eqterr1"
    t.float "pl_eqterr2"
    t.integer "pl_eqtlim"
    t.integer "ttv_flag"
    t.string "st_refname"
    t.string "st_spectype"
    t.float "st_teff"
    t.float "st_tefferr1"
    t.float "st_tefferr2"
    t.integer "st_tefflim"
    t.float "st_rad"
    t.float "st_raderr1"
    t.float "st_raderr2"
    t.integer "st_radlim"
    t.float "st_mass"
    t.float "st_masserr1"
    t.float "st_masserr2"
    t.integer "st_masslim"
    t.float "st_met"
    t.float "st_meterr1"
    t.float "st_meterr2"
    t.integer "st_metlim"
    t.string "st_metratio"
    t.float "st_logg"
    t.float "st_loggerr1"
    t.float "st_loggerr2"
    t.integer "st_logglim"
    t.string "sy_refname"
    t.string "rastr"
    t.float "ra"
    t.string "decstr"
    t.float "dec"
    t.float "sy_dist"
    t.float "sy_disterr1"
    t.float "sy_disterr2"
    t.float "sy_vmag"
    t.float "sy_vmagerr1"
    t.float "sy_vmagerr2"
    t.float "sy_kmag"
    t.float "sy_kmagerr1"
    t.float "sy_kmagerr2"
    t.float "sy_gaiamag"
    t.float "sy_gaiamagerr1"
    t.float "sy_gaiamagerr2"
    t.date "rowupdate"
    t.date "pl_pubdate"
    t.date "releasedate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stars", force: :cascade do |t|
    t.string "catalog_id"
    t.string "component_type"
    t.string "source"
    t.decimal "ra", precision: 12, scale: 8
    t.decimal "dec", precision: 12, scale: 8
    t.decimal "pm_ra", precision: 10, scale: 2
    t.decimal "pm_dec", precision: 10, scale: 2
    t.decimal "v_mag", precision: 6, scale: 3
    t.decimal "bt_mag", precision: 6, scale: 3
    t.decimal "vt_mag", precision: 6, scale: 3
    t.string "tycho_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "mass_flame"
    t.float "parallax"
    t.float "phot_g_mean_mag"
    t.float "age_flame"
  end

end
