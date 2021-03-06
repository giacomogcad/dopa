#!/bin/bash
##PROCESS GROADS 
date

set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

## Derived variables
((NTILES=${NCORES}-1))
LOCATION_MO_PATH=${DATABASE}/${LOCATION_MO}
PERMANENT_MO_MAPSET=${DATABASE}/${LOCATION_MO}"/PERMANENT"
BU_LIST_FILE=${SERVICEDIR}/${bu_tc_list}.txt

## GRASS parallel processing block
((ALLPAS=$(cat ${BU_LIST_FILE} | wc -l)+1))
((TILESIZE=($ALLPAS+($NCORES-1))/$NCORES))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	TIL=${TIL}
	TEMPORARY_MAPSET=tile_${TIL}
	TEMPORARY_MAPSET_PATH=${LOCATION_MO_PATH}/${TEMPORARY_MAPSET}
	#Build temporary Mapset name
	grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${TEMPORARY_MAPSET}
	echo "./slave_groads_bu.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${BU_LIST_FILE} ${BU_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_groads_bu.log

echo "GRASS Processing completed, now post-processing results..."

# merge results
cat ${RESULTSPATH}/bu_groads_tile*.csv >> ${RESULTSPATH}/bu_groads.csv
wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	rm -rf ${LOCATION_MO_PATH}/tile_${TIL}
	rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING of GROADS FOR PAs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/bu_groads.csv | awk '{print $1}' FS="|">./groads_actually_done.csv
comm -23 <(sort ${BU_LIST_FILE}) <(sort ./groads_actually_done.csv)>./groads_to_be_repeated.csv
MISSING_BU_LIST="groads_to_be_repeated.csv"
for BU in $(cat ${MISSING_BU_LIST})
	do
	grass ${PERMANENT_MO_MAPSET} --exec ./dyn/process_bu_groads_${BU}.sh
done
cat ${RESULTSPATH}/bu_groads_tile*.csv >> ${RESULTSPATH}/bu_groads.csv

## REMOUVE INVALID VALUES FROM CSV GENERATED BY r.univar
sed -i.bak 's/non_null_cells|null_cells|min|max|range|mean|mean_of_abs|stddev|variance|coeff_var|sum|sum_abs|first_quart|median|third_quart|perc_90/|||||||||||||||/g' ${RESULTSPATH}/bu_groads.csv
mv ${RESULTSPATH}/bu_groads.csv.bak ${RESULTSPATH}/bu_groads.orig
sed -i.bak 's/-nan/0/g' ${RESULTSPATH}/bu_groads.csv

rm -f ${RESULTSPATH}/*.bak

echo "Post-processing completed, now cleaning intermediate results..."

## delete intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done
rm -f ./*actually_done.csv
rm -f ./*to_be_repeated.csv

## delete dynamic scripts
rm -f ./dyn/process_bu_groads_*.sh

date
exit
