class GaiaQueryJob < ApplicationJob
  queue_as :default

  def perform(exoplanet, session_id)
    @exoplanets = Exoplanet.all

    # Fetch Gaia data for the stars
    stars_data = GaiaQueryService.new.fetch_gaia_data(exoplanet.ra, exoplanet.dec)
    # Broadcast the update with locals passed to the partial
    Turbo::StreamsChannel.broadcast_update_to "gaia-channel-#{session_id}",
      target: "main-frame",
      partial: "exoplanets/night_sky",
      locals: { exoplanet: exoplanet, stars: stars_data }
  end
end
