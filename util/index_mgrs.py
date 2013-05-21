from osgeo import ogr, osr
import re, mgrs, json, sys, urllib2

wgs84 = osr.SpatialReference()
wgs84.SetWellKnownGeogCS("EPSG:4326")

def get_fields_as_dict(layer, key_field='Name', rename_map={
    'Latitude': 'lat', 'Longitude': 'lon', 'URL': 'url',
    'Folder': 'collection', 'Thumb': 'thumbnail', 'ImageCaptu': 'captured_at'
}):
    """Given an OGR layer, builds a dictionary containing the fields for each
    feature.  In each dictionary item, the key is the specified key_field and
    the value is a dictionary containing the rest of the fields, optionally
    renamed according to the given rename_map."""
    results = {}
    for i in range(layer.GetFeatureCount()):
        feature = layer.GetFeature(i)
        value = dict((rename_map.get(field, field), feature.GetField(field))
                     for field in feature.keys())
        results[value.pop(key_field)] = value
    return results

_box_memo = {}
def get_mgrs_box(cell):
    """Given an MGRS string, returns the 5-point box for the MGRS cell."""
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

def add_mgrs_coords(feature_dicts):
    """Given a list of dictionaries, takes the 'lat' and 'lon' values
    in each dictionary, converts them to MGRS, and deposits the MGRS string
    in 'mgrs' and the 5-point closed polyline for the MGRS cell in 'box'."""
    to_mgrs = mgrs.MGRS().toMGRS
    for feature_dict in feature_dicts:
        lat, lon = feature_dict['lat'], feature_dict['lon']
        cell = to_mgrs(lat, lon, MGRSPrecision=2)
        feature_dict['mgrs'] = cell
        feature_dict['box'] = get_mgrs_box(cell)

def shapefile_to_json(shp_filename, json_filename):
    # Need to hold data_source ref; see http://trac.osgeo.org/gdal/ticket/4914
    data_source = ogr.Open(shp_filename)
    layer = data_source.GetLayer()
    feature_dicts = get_fields_as_dict(layer)
    add_mgrs_coords(feature_dicts.values())
    output = open(json_filename, 'w')
    json.dump(feature_dicts, output, indent=2)
    output.close()

def get_esri_fields_as_dict(esri, key_field="Filename", rename_map = {
    'latitude': 'lat', 'longitude': 'lon', 'ImageURL': 'url',
    'ThumbnailURL': 'thumbnail', 'strDateCaptured': 'captured_at'
    }):
    features = {}
    for item in esri["features"]:
        feature = item["attributes"]
        value = dict((rename_map.get(field, field), feature[field]) for field in feature.keys())
        features[value.pop(key_field)] = value
    return features

def esri_json_to_json(esri_file, json_filename):
    esri = json.load(esri_file)
    features = get_esri_fields_as_dict(esri)
    add_mgrs_coords(features.values())
    output = open(json_filename, 'w')
    json.dump(features, output, indent=2)
    output.close()

def fetch_esri_json(url, event_id):
    # 'http://50.18.155.202/arcgis/rest/services/CAPImages/MapServer/0/query?where=EventID%3D6&outFields=*&returnGeometry=true&f=pjson'
    url = url + '/arcgis/rest/services/CAPImages/MapServer/0/query?where=EventID%%3D%d&outFields=*&returnGeometry=true&f=pjson' % event_id
    return urllib2.urlopen(url)

if __name__ == '__main__':
    args = sys.argv[1:]
    if len(args) == 2:
        if args[0].endswith(".shp"):
            shapefile_to_json(args[0], args[1])
        else:
            data = file(args[0])
            esri_json_to_json(data, args[-1])
    elif len(args) == 3:
        data = fetch_esri_json(args[0], int(args[1]))
        esri_json_to_json(data, args[-1])
    else:
        raise SystemExit('Usage: %s <infile.shp> <outfile.json>' % sys.argv[0])
