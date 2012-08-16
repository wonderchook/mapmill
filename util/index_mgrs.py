from osgeo import gdal, osr
import re, mgrs, json

wgs84 = osr.SpatialReference()
wgs84.SetWellKnownGeogCS("EPSG:4326")

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

_box_memo = {}
def get_mgrs_box(cell):
    if cell in _box_memo: return _box_memo[cell]
    m = mgrs.MGRS()
    lat, lon = m.toLatLon(cell)

    zone = int(1 + (lon + 180) / 6)
    utm = osr.SpatialReference()
    utm.SetUTM(zone)

    xform = osr.CoordinateTransformation(wgs84, utm)
    east, north, _ = xform.TransformPoint(lon, lat)

    xform = osr.CoordinateTransformation(utm, wgs84)
    precision = re.findall(r'\d+$', cell)[0]
    size = 10 ** (5 - len(precision) / 2)
    corners = []
    for e, n in ((east, north), (east, north + size),
                 (east + size, north + size), (east + size, north),
                 (east, north)):
        x, y, _ = xform.TransformPoint(e, n)
        corners.append((x, y))
    _box_memo[cell] = tuple(corners)
    return _box_memo[cell]

if __name__ == "__main__":
    import sys, os
    m = mgrs.MGRS()
    for dir in sys.argv[1:]:
        cells, files = {}, {}
        for filename in os.listdir(dir):
            if not filename.endswith(".JPG"): continue
            lon, lat = get_gps_coords(os.path.join(dir, filename))
            cell = m.toMGRS(lat, lon, MGRSPrecision=3)
            box = get_mgrs_box(cell)
            files[filename] = {"lon": lon, "lat": lat, "mgrs": cell, "box": box}
        idx = file(os.path.join(dir, "index.json"), "w")
        json.dump(files, idx, indent=2)
