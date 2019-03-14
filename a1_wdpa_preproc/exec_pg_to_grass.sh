#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

## Derived variables
##((NCORES=${1:-DEFAULTVALUE}))
((NTILES=${NCORES}-1))
LOCATION_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_MAPSET_PATH=${DATABASE}/${LOCATION_LL}"/PERMANENT"
PA_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${PA_MAPSET}
BU_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${BU_MAPSET}
PA_LIST_FILE=${SERVICEDIR}/${pa_list}.txt
BU_LIST_FILE=${SERVICEDIR}/${bu_list}.txt
dbpars="-h ${host} -u ${user} -P ${pw}"
WDPA_MAPSET=${DATABASE}/${LOCATION_LL}"/WDPA_"${wdpadate}
FLAT="wdpa_flat@WDPA_"${wdpadate}


## PARALLEL PROCESSING BLOCK: EXPORT PAs TO SHAPEFILE
((ALLPAS=$(cat ${PA_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLPAS}+(${NCORES}-1))/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
schema=${pa_schema}
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
	TIL=${TIL}
	echo "./slave_pg_to_grass.sh ${SHPDIR_PA} ${schema} ${PA_LIST_FILE} ${TIL} ${TILESIZE} ${host} ${user} ${pw} ${db}"
done | parallel -j ${NCORES}

## SECOND CYCLE: REPEAT PROCESSING FOR MISSING SHPs OF PAs
ls -l ${SHPDIR_PA}/*.shp| awk '{print $9}' FS=" "| cut -d "." -f 1| xargs -n 1 basename>./shps_pa_actually_done.csv
comm -23 <(sort ${PA_LIST_FILE}) <(sort ./shps_pa_actually_done.csv)>./shps_pa_to_be_repeated.csv
MISSING_PA_LIST="shps_pa_to_be_repeated.csv"

for PA in $(cat ${MISSING_PA_LIST})
	do
	pgsql2shp -f ${SHPDIR_PA}/${PA} ${dbpars} ${db} "SELECT * FROM ${pa_schema}.${PA}"
done

echo " "
echo "Individual views for PAs exported in shapefile"
echo " "

## PARALLEL PROCESSING BLOCK: EXPORT BUFFERS TO SHAPEFILE
((ALLPAS=$(cat ${BU_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLPAS}+(${NCORES}-1))/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
schema=${bu_schema}
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
	TIL=${TIL}
	echo "./slave_pg_to_grass.sh ${SHPDIR_BU} ${schema} ${BU_LIST_FILE} ${TIL} ${TILESIZE} ${host} ${user} ${pw} ${db}"
done | parallel -j ${NCORES}


## SECOND CYCLE: REPEAT PROCESSING FOR MISSING SHPs OF BUFFERS
ls -l ${SHPDIR_BU}/*.shp| awk '{print $9}' FS=" "| cut -d "." -f 1| xargs -n 1 basename>./shps_bu_actually_done.csv
comm -23 <(sort ${BU_LIST_FILE}) <(sort ./shps_bu_actually_done.csv)>./shps_bu_to_be_repeated.csv
MISSING_BU_LIST="shps_bu_to_be_repeated.csv"

for BU in $(cat ${MISSING_BU_LIST})
	do
	pgsql2shp -f ${SHPDIR_BU}/${BU} ${dbpars} ${db} "SELECT * FROM ${bu_schema}.${BU}"
done

# rm -f shps_*

echo " "
echo "Individual views for BUFFERS exported in shapefile"


## IMPORT SHPs in GRASS (PAs and BUFFERS). Buffers are erased with wdpa_flat in order to keep only the unprotected portion.
echo " "
echo "Now importing shapefiles to GRASS DB..."
echo " "

grass ${PERMANENT_MAPSET_PATH} --exec g.mapset --q -c --overwrite mapset=${PA_MAPSET}
grass ${PERMANENT_MAPSET_PATH} --exec g.mapset --q -c --overwrite mapset=${BU_MAPSET}

#IMPORT PAs
for PA in $(cat ${PA_LIST_FILE})
	do
	grass ${PA_MAPSET_PATH} --exec v.in.ogr --quiet --overwrite -o -t input=${SHPDIR_PA}/${PA}.shp output=${PA%} key=wdpaid
	wait
done &

#IMPORT AND PROCESS BUs
for BU in $(cat ${BU_LIST_FILE})
	do
	echo "./slave_unprot_buffer.sh ${BU} ${SHPDIR_BU} ${BU_MAPSET_PATH} ${FLAT}"
done |parallel -j 1

#DELETE BUFFERS WITH EMPTY GEOMETRIES
for BU in $(cat ${BU_LIST_FILE})
	do
	## the following is aimed to write a list of buffers resulting in empty geometry (i.e. buffers fully protected by other PAs)
	mm=`grass ${BU_MAPSET_PATH} --exec v.report map=${BU} option=coor| tail -n +1|wc -l`
	if (( ${mm} == 1 ))
	then echo ${BU}>>${WORKINGDIR}/bus_to_be_deleted.csv
	grass ${BU_MAPSET_PATH} --exec g.remove type=vector name=${BU} -f
	fi
done |parallel -j 1

wait

#UPDATE LIST files  OF BUs
for BU in $(cat ${WORKINGDIR}/bus_to_be_deleted.csv)
do
	# UPDATE FULL LIST
	grep -w -v ${BU} ${SERVICEDIR}/${bu_list}.txt >${SERVICEDIR}/temp_bu.txt
	mv ${SERVICEDIR}/temp_bu.txt ${SERVICEDIR}/${bu_list}.txt
	# UPDATE LIST OF TERRESTRIAL AND COASTAL PAs
	grep -w -v ${BU} ${SERVICEDIR}/${bu_tc_list}.txt >${SERVICEDIR}/temp_bu_tc.txt
	mv ${SERVICEDIR}/temp_bu_tc.txt ${SERVICEDIR}/${bu_tc_list}.txt
	# UPDATE LIST OF MARINE PAs
	grep -w -v ${BU} ${SERVICEDIR}/${bu_ma_list}.txt >${SERVICEDIR}/temp_bu_ma.txt
	mv ${SERVICEDIR}/temp_bu_ma.txt ${SERVICEDIR}/${bu_ma_list}.txt
done


rm -f ${WORKINGDIR}/shps_*
rm -f ${WORKINGDIR}/bus_to_be_deleted.csv
rm -f >${SERVICEDIR}/temp*
rm -f ./dyn/unprot_buffer.sh


echo " "
echo "Individual shapefiles of PAs and BUFFERS imported in GRASS DB"
echo " "

finaldate=`date`
echo " "
echo "---------------------------------------------------"
echo "Data export from PG to GRASS DB completed at ${finaldate}"
echo " "
exit
