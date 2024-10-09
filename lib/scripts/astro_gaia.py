import sys
import logging
from astroquery.gaia import Gaia
import astropy.units as u
from astropy.coordinates import SkyCoord
import json

# Disable astroquery logs
logging.getLogger('astroquery').setLevel(logging.ERROR)

def query_gaia_v1(ra, dec):
    coord = SkyCoord(ra=float(ra), dec=float(dec), unit=(u.degree, u.degree), frame='icrs')
    width = u.Quantity(0.1, u.deg)
    height = u.Quantity(0.1, u.deg)
    r = Gaia.query_object_async(coordinate=coord, width=width, height=height)
    
    # Convert the result to JSON format
    result = r.to_pandas().to_json(orient='records')
    return result

def query_gaia_v2():
    # Query bright stars (magnitude less than 10) across the entire sky
    query = """
    SELECT TOP 20000 source_id, ra, dec, parallax, phot_g_mean_mag 
    FROM gaiadr3.gaia_source
    WHERE phot_g_mean_mag < 10
    AND source_id IS NOT NULL
    AND parallax IS NOT NULL
    AND ra IS NOT NULL
    AND dec IS NOT NULL
    ORDER BY phot_g_mean_mag ASC
    """
    job = Gaia.launch_job_async(query)
    
    # Convert the result to a pandas dataframe and then to JSON
    result = job.get_results().to_pandas().to_json(orient='records')
    return result

if __name__ == "__main__":
    # Get RA and Dec from command-line arguments
    # ra = sys.argv[1]
    # dec = sys.argv[2]
    
    # Perform Gaia query
    # result = query_gaia_v1(ra, dec)
    result = query_gaia_v2()
    
    # Print the result
    print(result)