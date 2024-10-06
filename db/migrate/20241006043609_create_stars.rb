class CreateStars < ActiveRecord::Migration[7.1]
  def change
    create_table :stars do |t|
      t.string :catalog_id
      t.string :component_type
      t.string :source
      t.decimal :ra, precision: 12, scale: 8  # Right Ascension
      t.decimal :dec, precision: 12, scale: 8 # Declination
      t.decimal :pm_ra, precision: 10, scale: 2 # Proper Motion in RA
      t.decimal :pm_dec, precision: 10, scale: 2 # Proper Motion in DEC
      t.decimal :v_mag, precision: 6, scale: 3 # V Magnitude
      t.decimal :bt_mag, precision: 6, scale: 3 # BT Magnitude
      t.decimal :vt_mag, precision: 6, scale: 3 # VT Magnitude
      t.string :tycho_flag
      t.timestamps
    end
  end
end
