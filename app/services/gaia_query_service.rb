class GaiaQueryService
  def fetch_gaia_data(ra, dec)
    # Call the Python script with parameters
    result = `python3 lib/scripts/astro_gaia.py #{ra} #{dec}`
    # Parse the JSON result returned by the Python script
    JSON.parse(result)
  end
end