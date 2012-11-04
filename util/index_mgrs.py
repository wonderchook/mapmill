from osgeo import gdal, osr
import re, mgrs, json

wgs84 = osr.SpatialReference()
wgs84.SetWellKnownGeogCS("EPSG:4326")

def parse_gps_exif(tag):
    d, m, s = map(float, re.findall(r"\(([\d\.]+)\)", tag))
    return d + m / 60 + s / 3600

def get_exif_coords(filename):
    ds = gdal.Open(filename)
    if not ds: return None, None
    lat = ds.GetMetadataItem("EXIF_GPSLatitude")
    lon = ds.GetMetadataItem("EXIF_GPSLongitude")
    if lat is None or lon is None:
        return None, None
    lat_n = 1 if ds.GetMetadataItem("EXIF_GPSLatitudeRef") == "N" else -1
    lon_e = 1 if ds.GetMetadataItem("EXIF_GPSLongitudeRef") == "E" else -1
    return lon_e * parse_gps_exif(lon), \
           lat_n * parse_gps_exif(lat)


def get_gps_coords(filename):
    "AE00N41_721928W071_1493402012103000000000OL02_BU001002003.jpg"
    match = re.findall(r'([NS])(\d\d)_(\d{6})([EW])(\d\d\d)_(\d{6})', filename)
    if not match: return get_exif_coords(filename)
    ns, lat, lat_dec, ew, lon, lon_dec = match[0]
    ns = 1 if ns == 'N' else -1
    ew = 1 if ew == 'E' else -1
    lat = (float(lat) + float(lat_dec) / 1000000) * ns
    lon = (float(lon) + float(lon_dec) / 1000000) * ew
    return lon, lat

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
            if not filename.lower().endswith(".jpg"): continue
            embedded_mgrs = re.findall(r"^\w+_(\d\d[A-Z]{3}\d{4}).\w+$", filename)
            if embedded_mgrs:
                cell = embedded_mgrs[0]
            else:
                try:
                    lon, lat = get_gps_coords(os.path.join(dir, filename))
                    if lon is None or lat is None: raise TypeError("no GPS data")
                    cell = m.toMGRS(lat, lon, MGRSPrecision=2)
                except TypeError:
                    #print >>sys.stderr, "Can't read metadata from", dir + "/" + filename
                    continue
            box = get_mgrs_box(cell)
            files[filename] = {"lon": lon, "lat": lat, "mgrs": cell, "box": box}
        idx = file(os.path.join(dir, "index.json"), "w")
        json.dump(files, idx, indent=2)
