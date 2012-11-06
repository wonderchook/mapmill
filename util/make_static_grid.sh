#!/bin/bash
SITE=${1:-sandy}
echo $SITE
cd /mnt/mapmill/public/grid/static
curl http://sandy.hotosm.org/grid/${SITE}.json -o ${SITE}.json
ogr2ogr ${SITE}_hotosm_damage.shp ${SITE}.json
zip -9 --move ${SITE}_hotosm_damage.zip ${SITE}_hotosm_damage.*
