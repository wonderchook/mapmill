#!/bin/bash
SITE=${1:-sandy}
STATIC=`dirname $0`/../public/grid/static
mkdir -p ${STATIC}
cd ${STATIC}
curl http://localhost/grid/${SITE}.json -o ${SITE}.json
ogr2ogr ${SITE}_hotosm_damage.shp ${SITE}.json
zip -9 --move ${SITE}_hotosm_damage.zip ${SITE}_hotosm_damage.*
