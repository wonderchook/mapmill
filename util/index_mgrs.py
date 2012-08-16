from osgeo import gdal
import re, mgrs, json

def parse_gps_exif(tag):
    d, m, s = map(float, re.findall(r"\(([\d\.]+)\)", tag))
    return d + m / 60 + s / 3600

def get_gps_coords(filename):
    ds = gdal.Open(filename)
    lat = ds.GetMetadataItem("EXIF_GPSLatitude")
    lon = ds.GetMetadataItem("EXIF_GPSLongitude")
    lat_n = 1 if ds.GetMetadataItem("EXIF_GPSLatitudeRef") == "N" else -1
    lon_e = 1 if ds.GetMetadataItem("EXIF_GPSLongitudeRef") == "E" else -1
    return lon_e * parse_gps_exif(lon), \
           lat_n * parse_gps_exif(lat)

if __name__ == "__main__":
    import sys, os
    m = mgrs.MGRS()
    for dir in sys.argv[1:]:
        files = {}
        for filename in os.listdir(dir):
            lon, lat = get_gps_coords(os.path.join(dir, filename))
            cell = m.toMGRS(lat, lon)
            files[filename] = {"lon": lon, "lat": lat, "mgrs": cell}
        idx = file(os.path.join(dir, "index.json"), "w")
        json.dump(files, idx, indent=2)
