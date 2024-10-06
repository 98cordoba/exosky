class AddMissingAttributesToStars < ActiveRecord::Migration[7.1]
  def change
    add_column :stars, :mass_flame, :float
    add_column :stars, :parallax, :float
    add_column :stars, :phot_g_mean_mag, :float
    add_column :stars, :age_flame, :float
  end
end
