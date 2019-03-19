#!/bin/bash
##PROCESS BUILT UP 2017
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
((NTILES=$NCORES-1))
((ALLPAS=$(cat ${PA_LIST_FILE} | wc -l)+1))
((TILESIZE=($ALLPAS+($NCORES-1))/$NCORES))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    TIL=${TIL}
    TEMPORARY_MAPSET=tile_${TIL}
    TEMPORARY_MAPSET_PATH=${LOCATION_MO_PATH}/${TEMPORARY_MAPSET}
    #Build temporary Mapset name
    grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${TEMPORARY_MAPSET}
    echo "./slave_cat_30m_pa.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${PA_LIST_FILE} ${PA_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_cat30m_pa.log

# merge results
cat ${RESULTSPATH}/pa_gfc_totsurface_t*.csv >> ${RESULTSPATH}/pa_gfc_totsurface.csv
cat ${RESULTSPATH}/pa_gfc_gain_t*.csv >> ${RESULTSPATH}/pa_gfc_gain.csv
cat ${RESULTSPATH}/pa_gfc_lossyear_t*.csv >> ${RESULTSPATH}/pa_gfc_lossyear.csv
cat ${RESULTSPATH}/pa_gsw_t*.csv >> ${RESULTSPATH}/pa_gsw.csv

wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	rm -rf ${LOCATION_MO_PATH}/tile_${TIL}
	rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING of GFC AND GSW FOR PAs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/pa_gfc_gain.csv | awk '{print $2}' FS="|">./gfc_actually_done.csv
comm -23 <(sort ${PA_LIST_FILE}) <(sort ./gfc_actually_done.csv)>./gfc_to_be_repeated.csv
MISSING_PA_LIST="gfc_to_be_repeated.csv"
for PA in $(cat ${MISSING_PA_LIST})
	do
	grass ${PERMANENT_MO_MAPSET} --exec ./dyn/process_cat30m_pa_${PA}.sh
done

cat ${RESULTSPATH}/pa_gfc_totsurface_t*.csv >> ${RESULTSPATH}/pa_gfc_totsurface.csv
cat ${RESULTSPATH}/pa_gfc_gain_t*.csv >> ${RESULTSPATH}/pa_gfc_gain.csv
cat ${RESULTSPATH}/pa_gfc_lossyear_t*.csv >> ${RESULTSPATH}/pa_gfc_lossyear.csv
cat ${RESULTSPATH}/pa_gsw_t*.csv >> ${RESULTSPATH}/pa_gsw.csv
cp ${RESULTSPATH}/pa_gfc_totsurface.csv ${RESULTSPATH}/pa_gsw_totsurface.csv #r.stats for totsurface is not run on gsw_transitions since it uses the same mask of GFC

## delete intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

rm -f ./*actually_done.csv
rm -f ./*to_be_repeated.csv

## delete dynamic scripts
rm -f ./dyn/process_cat30m_pa_*.sh

date
exit
