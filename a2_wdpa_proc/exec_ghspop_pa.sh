#!/bin/bash
##PROCESS GHS POPULATION
date

set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

## Derived variables
((NTILES=${NCORES}-1))
LOCATION_MO_PATH=${DATABASE}/${LOCATION_MO}
PERMANENT_MO_MAPSET=${DATABASE}/${LOCATION_MO}"/PERMANENT"
PA_LIST_FILE=${SERVICEDIR}/${pa_tc_list}.txt

## GRASS parallel processing block
((ALLPAS=$(cat ${PA_LIST_FILE} | wc -l)+1))
((TILESIZE=($ALLPAS+($NCORES-1))/$NCORES))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	TIL=${TIL}
	TEMPORARY_MAPSET=tile_${TIL}
	TEMPORARY_MAPSET_PATH=${LOCATION_MO_PATH}/${TEMPORARY_MAPSET}
	#Build temporary Mapset name
	grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${TEMPORARY_MAPSET}
	echo "./slave_ghspop_pa.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${PA_LIST_FILE} ${PA_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_ghspop_pa.log

echo "GRASS Processing completed, now post-processing results..."

# merge results
cat ${RESULTSPATH}/pa_pop1975_tile*.csv >> ${RESULTSPATH}/pa_pop1975.csv
cat ${RESULTSPATH}/pa_pop1990_tile*.csv >> ${RESULTSPATH}/pa_pop1990.csv
cat ${RESULTSPATH}/pa_pop2000_tile*.csv >> ${RESULTSPATH}/pa_pop2000.csv
cat ${RESULTSPATH}/pa_pop2015_tile*.csv >> ${RESULTSPATH}/pa_pop2015.csv

wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	rm -rf ${LOCATION_MO_PATH}/tile_${TIL}
	rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING of GHS POP FOR PAs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/pa_pop2015.csv | awk '{print $1}' FS="|">./ghspop_actually_done.csv
comm -23 <(sort ${PA_LIST_FILE}) <(sort ./ghspop_actually_done.csv)>./ghspop_to_be_repeated.csv
MISSING_PA_LIST="ghspop_to_be_repeated.csv"
for PA in $(cat ${MISSING_PA_LIST})
	do
	grass ${PERMANENT_MO_MAPSET} --exec ./dyn/process_pa_ghspop_${PA}.sh
done

cat ${RESULTSPATH}/pa_pop1975_tile*.csv >> ${RESULTSPATH}/pa_pop1975.csv
cat ${RESULTSPATH}/pa_pop1990_tile*.csv >> ${RESULTSPATH}/pa_pop1990.csv
cat ${RESULTSPATH}/pa_pop2000_tile*.csv >> ${RESULTSPATH}/pa_pop2000.csv
cat ${RESULTSPATH}/pa_pop2015_tile*.csv >> ${RESULTSPATH}/pa_pop2015.csv

## REMOUVE INVALID VALUES FROM CSV GENERATED BY r.univar
sed -i.bak 's/non_null_cells|null_cells|min|max|range|mean|mean_of_abs|stddev|variance|coeff_var|sum|sum_abs|first_quart|median|third_quart|perc_90/|||||||||||||||/g' ${RESULTSPATH}/pa_pop*.csv
mv ${RESULTSPATH}/pa_pop1975.csv.bak ${RESULTSPATH}/pa_pop1975.orig
mv ${RESULTSPATH}/pa_pop1990.csv.bak ${RESULTSPATH}/pa_pop1990.orig
mv ${RESULTSPATH}/pa_pop2000.csv.bak ${RESULTSPATH}/pa_pop2000.orig
mv ${RESULTSPATH}/pa_pop2015.csv.bak ${RESULTSPATH}/pa_pop2015.orig
sed -i.bak 's/-nan/0/g' ${RESULTSPATH}/pa_pop*.csv

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
rm -f ./dyn/process_pa_ghspop_*.sh

date
exit