from astroquery.gaia import Gaia
import astropy.units as u
from astropy.coordinates import SkyCoord
import json
import sys
import multiprocessing  

data = multiprocessing.Manager().list()  

def query_gaia_data(ra, dec, radius, x):
    """
    Consulta la base de datos de Gaia en un radio de búsqueda alrededor de coordenadas dadas.
    """

    # Crear objeto de coordenadas
    coord = SkyCoord(ra=ra*u.degree, dec=dec*u.degree, frame='icrs')
    radius = u.Quantity(radius, u.deg)

    # Ejecutar la consulta con Gaia
    query = f"""
    SELECT TOP 50 source_id, ra, dec, phot_g_mean_mag, parallax 
    FROM gaiadr3.gaia_source
    WHERE CONTAINS(POINT('ICRS', gaia_source.ra, gaia_source.dec),
                   CIRCLE('ICRS', {ra}, {dec}, {radius.to(u.deg).value})) = 1
    ORDER BY phot_g_mean_mag ASC
    """
    
    job = Gaia.launch_job(query)
    result_table = job.get_results()

    # Agrega los resultados a la lista compartida 'data'
    for row in result_table:
        data.append({
            "source_id": int(row['source_id']),
            "ra": float(row['ra']),
            "dec": float(row['dec']),
            "phot_g_mean_mag": float(row['phot_g_mean_mag']),
            "parallax": float(row['parallax']),
        })

    return result_table


def get_gaia_data(ra, dec, radius):
    """
    Paraleliza las consultas a la base de datos de Gaia y almacena los resultados en 'data'.
    """
    pool = multiprocessing.Pool()  

    for x in range(0, 360, 6):
        pool.apply_async(query_gaia_data, args=(ra, dec, radius, x))  # Ejecutar en paralelo

    pool.close()  # No aceptar más tareas
    pool.join()   # Esperar a que todos los procesos terminen
    
    return data


def the_gaia_to_json():
    """
    Convierte los datos almacenados en 'data' a formato JSON.
    """
    return json.dumps(list(data), indent=5)  # Convertir 'data' a una lista normal


if __name__ == '__main__':
    # Asegúrate de que los argumentos se pasan como flotantes
    ra = float(sys.argv[1])
    dec = float(sys.argv[2])
    radius = 6  # Puedes ajustar el valor del radio según sea necesario

    # Llamar a la función para obtener los datos de Gaia usando multiprocessing
    complete_data = get_gaia_data(ra, dec, radius)

    # Imprimir los datos en formato JSON
    json_result = the_gaia_to_json()
    print(json_result)
