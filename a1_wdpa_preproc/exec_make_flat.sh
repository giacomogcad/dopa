#!/bin/bash
## IMPORT FULL WDPA IN GRASS AND MARE RASTER FLAT

date

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

## Derived variables
dbpar="-h ${host} -U ${user} -d ${db}"
LOCATION_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
WDPA_MAPSET=${DATABASE}/${LOCATION_LL}"/WDPA_"${wdpadate}

# ## Create and access mapset
# # g.mapset --q -c --overwrite mapset=WDPA_201901
# grass ${PERMANENT_MAPSET} --exec g.mapset --q -c WDPA_${wdpadate}

# ## CREATE DB CONNECTION TO POSTGIS
# grass ${PERMANENT_MAPSET} --exec db.connect driver=pg database=${db} schema=${wdpa_schema}
# ## THE PASSWORD IS FAKE
# grass ${PERMANENT_MAPSET} --exec db.login --overwrite driver=pg database=${db} user=${user} password=${pw} host=${host} port=${port}

# ## IMPORT WDPA FROM POSTGIS
# echo "Now importing wdpa_${wdpadate}..."
# grass ${PERMANENT_MAPSET} --exec g.mapset --q -c WDPA
# grass ${WDPA_MAPSET} --exec v.in.ogr --q --overwrite -t -o input="PG:host=${host} dbname=${db} user=${user} password=${pw}" columns=cat,id,wdpaid snap=0.0000083 layer=${wdpa_schema}.wdpa_"${wdpadate}" output=wdpa_flat >>${LOGPATH}wdpa_flat.log  2>&1

# wait

# execute flat_slave.sh
grass ${WDPA_MAPSET} --exec sh ./slave_make_flat.sh wdpa_${wdpadate} ## >>${LOGPATH}wdpa_flat.log  2>&1

date
exit
