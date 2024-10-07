class ExoplanetsController < ApplicationController
  def show
    @exoplanets = Exoplanet.all
    @exoplanet = Exoplanet.find(params[:id])
    @gaia_data = GaiaQueryService.new.fetch_gaia_data(@exoplanet.ra, @exoplanet.dec)
    render json: {
      exoplanet: {
        ra: @exoplanet.ra,
        dec: @exoplanet.dec,
        sy_dist: @exoplanet.sy_dist,  # Distance of the exoplanet in parsecs
        st_teff: @exoplanet.st_teff,  # Star temperature
        st_rad: @exoplanet.st_rad,    # Star radius
        pl_rade: @exoplanet.pl_rade,  # Planet radius in Earth radii
        pl_bmasse: @exoplanet.pl_bmasse, # Planet mass in Earth masses
        sy_vmag: @exoplanet.sy_vmag,  # Star apparent magnitude
        pl_orbper: @exoplanet.pl_orbper, # Orbital period
        pl_eqt: @exoplanet.pl_eqt,    # Equilibrium temperature
      },
      stars: @gaia_data
    }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("main-frame", partial: "exoplanets/exoplanet", locals: { exoplanet: @exoplanet })
      end
      format.html { render :show }
    end
  end

  def loading
    @exoplanets = Exoplanet.all
    @session_id = SecureRandom.uuid
    @exoplanet = Exoplanet.find(params[:id])

    GaiaQueryJob.perform_later(@exoplanet, @session_id)

    @exoplanet = Exoplanet.find(params[:id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("main-frame", partial: "exoplanets/loading", locals: { exoplanet: @exoplanet })
      end
      format.html { render :show }
    end
  end
end
